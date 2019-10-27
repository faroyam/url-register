use Mix.Config

config :url_register,
  cowboy_port: 8080,
  redis_url: "127.0.0.1",
  redis_port: 6379

config :logger, :console, level: :info
