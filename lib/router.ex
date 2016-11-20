defmodule More.Router do
  use Plug.Router
  use Plug.Debugger

  plug Plug.Logger
  plug Plug.Parsers, parsers: [:urlencoded]
  plug Plug.Static,
    at: "/",
    from: :more,
    only: ~w(css images js favicon.ico robots.txt)
  plug :match
  plug :dispatch

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
    bindings = [assigns: [
      ig_login_url: conn |> Instagram.get_authorize_url
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
        ig_user_id: resp.body[:user]["id"],
        ig_access_token: resp.body[:access_token]
      })
      |> More.UserService.login
      |> More.Repo.transaction
    case result do
      {:ok, %{user: user}} ->
        conn
        |> redirect("/")
      {:error, _failed_operation, _failed_value, _changes_so_far} ->
        conn
        |> send_resp(500, "Oops!")
    end
  end

  match _ do
    conn |> send_resp(404, "Not found")
  end
end
