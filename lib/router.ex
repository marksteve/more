defmodule More.Router do
  use Plug.Router
  use Plug.Debugger

  plug Plug.Static,
    at: "/",
    from: :more,
    only: ~w(css images js favicon.ico robots.txt)

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.Session,
    store: :cookie,
    key: "_more_key",
    encryption_salt: "cookie store encryption salt",
    signing_salt: "cookie store signing salt",
    key_length: 64,
    log: :debug

  plug :put_secret_key_base
  plug :match
  plug :dispatch

  def put_secret_key_base(conn, _) do
    put_in conn.secret_key_base, "gwAdwrjDiYN9UT8PX6w4lZz8VqKzeA8gKa5ogrCvIBx3TZyWNNDeu9bEPe3KrhPW"
  end

  def render_template(file_path, bindings \\ []) do
    file_path = Path.join("templates", file_path)
    file_path
    |> File.read!
    |> Expug.to_eex!(raw_helper: "")
    |> EEx.eval_string(bindings, file: file_path)
  end

  defp redirect(conn, location) do
    conn
    |> put_resp_header("location", location)
    |> send_resp(conn.status || 302, "")
  end

  get "/" do
    current_user = conn
    |> fetch_session
    |> get_session(:current_user)
    bindings = [assigns: [
      ig_login_url: conn |> Instagram.get_authorize_url,
      current_user: current_user |> IO.inspect,
      recent_media: current_user && current_user.ig_access_token |> Instagram.recent_media
    ]]
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, render_template("index.pug", bindings))
  end

  get "/oauth" do
    resp = conn
    |> Instagram.exchange_code
    result =
      %More.User{}
      |> More.User.login_changeset(%{
        user_name: resp.body["user"]["username"],
        profile_picture: resp.body["user"]["profile_picture"],
        ig_user_id: resp.body["user"]["id"],
        ig_access_token: resp.body["access_token"]
      })
      |> More.UserService.login
      |> More.Repo.transaction
    case result do
      {:ok, %{user: user}} ->
        conn
        |> fetch_session
        |> put_session(:current_user, user)
        |> redirect("/")
      {:error, _failed_operation, _failed_value, _changes_so_far} ->
        conn
        |> send_resp(500, "Oops!")
    end
  end

  match _ do
    conn
    |> send_resp(404, "Not found")
  end
end
