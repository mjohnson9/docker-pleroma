use Mix.Config

config :pleroma, Pleroma.Web.Endpoint,
   http: [ ip: {0, 0, 0, 0}, ],
   url: [host: "example.com", scheme: "https", port: 443],
   secret_key_base: ""

config :pleroma, :instance,
  name: "Pleroma",
  email: "admin@email.tld",
  limit: 5000,
  registrations_open: true

config :pleroma, :media_proxy,
  enabled: false,
  redirect_on_failure: true,
  base_url: "https://cache.domain.tld"

# Configure your database
config :pleroma, Pleroma.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "",
  password: "",
  database: "",
  hostname: "",
  pool_size: 10

config :pleroma, configurable_from_database: true