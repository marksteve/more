defmodule Instablog.Router do
  use Plug.Router
  use Plug.Debugger

  plug Plug.Logger
  plug Plug.Parsers, parsers: [:urlencoded]
  plug :match
  plug :dispatch

  def render_template(file_path, bindings \\ []) do
    file_path = Path.join("templates", file_path)
    file_path
    |> File.read!
    |> Expug.to_eex!(raw_helper: "")
    |> EEx.eval_string(bindings, file: file_path)
  end

  get "/" do
    bindings = [assigns: [
      client_id: System.get_env("SLACK_CLIENT_ID")
    ]]
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, render_template("index.pug", bindings))
  end

  match _ do
    conn |> send_resp(404, "Not found")
  end
end
