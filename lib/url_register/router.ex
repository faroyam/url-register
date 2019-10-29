defmodule UrlRegister.Router do
  use Plug.Router
  use Plug.ErrorHandler

  alias UrlRegister.Model
  alias UrlRegister.Redis
  alias UrlRegister.Plugs

  require Logger

  plug(Plug.LoggerJSON, log: Logger.level())
  plug(Plugs.VerifyQuery, query_params: ["from", "to"], paths: ["/visited_domains"])
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(Plugs.VerifyBody, body_params: ["links"], paths: ["/visited_links"])
  plug(:dispatch)

  post "/visited_links" do
    conn.body_params
    |> Map.get("links")
    |> Model.VisitedDomains.domains_from_links()
    |> Model.VisitedDomains.domains_to_store()
    |> Redis.save_domains()

    {status, body} = {200, "ok"}

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Model.Status.encode(body))
  end

  get "/visited_domains" do
    domains =
      Redis.get_domains(
        Map.get(conn.query_params, "from"),
        Map.get(conn.query_params, "to")
      )
      |> Model.VisitedDomains.domains_from_store()

    {status, body} = {200, Model.VisitedDomains.encode(domains, "ok")}

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, body)
  end

  match _ do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(404, Model.Status.encode("not found"))
  end

  defp handle_errors(conn, %{
         kind: kind,
         reason: reason,
         stack: stacktrace
       }) do
    Plug.LoggerJSON.log_error(kind, reason, stacktrace)

    body =
      cond do
        conn.status >= 400 && conn.status < 500 ->
          "bad request"

        true ->
          "internal error"
      end

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(conn.status, Model.Status.encode(body))
  end

  defp handle_errors(_, _), do: nil
end
