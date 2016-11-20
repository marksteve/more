use Mix.Config

config :more, ig_client_id:  "cd235499d38d4ba3bdb924a7c294646e"
config :more, ig_client_secret: "25c2f0b3691d47ca8bbce34b89a44b45"

config :more, More.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "more",
  username: "marksteve",
  password: "marksteve",
  hostname: "localhost"
  # OR use a URL to connect instead
  # url: "postgres://postgres:postgres@localhost/ecto_simple"
