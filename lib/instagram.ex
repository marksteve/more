defmodule Instagram do
  use HTTPoison.Base

  def process_url(url) do
    URI.merge("https://api.instagram.com", url) |> to_string()
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
    |> Enum.map(fn({k, v}) -> {String.to_atom(k), v} end)
  end

  def redirect_uri(conn) do
    URI.merge("http://#{conn.host}:#{conn.port}", "oauth") |> to_string()
  end

  def get_authorize_url(conn) do
    qs = URI.encode_query([
      client_id: Application.get_env(:more, :ig_client_id),
      redirect_uri: conn |> redirect_uri(),
      response_type: "code"
    ])
    "https://api.instagram.com/oauth/authorize/?#{qs}"
  end

  def exchange_code(conn) do
    post!("/oauth/access_token", {:form, [
      client_id: Application.get_env(:more, :ig_client_id),
      client_secret: Application.get_env(:more, :ig_client_secret),
      grant_type: "authorization_code",
      redirect_uri: conn |> redirect_uri(),
      code: conn.params["code"]
    ]})
  end
end
