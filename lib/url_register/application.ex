defmodule UrlRegister.Application do
  @moduledoc """

  """

  use Application

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: UrlRegister.Router, options: [port: cowboy_port()]},
      {Redix, host: redis_url(), port: redis_port(), name: :redix}
    ]

    opts = [strategy: :one_for_one, name: UrlRegister.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp cowboy_port, do: Application.get_env(:url_register, :cowboy_port, 8080)
  defp redis_url, do: Application.get_env(:url_register, :redis_url, "127.0.0.1")
  defp redis_port, do: Application.get_env(:url_register, :redis_port, 6379)
end
