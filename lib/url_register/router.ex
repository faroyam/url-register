defmodule UrlRegister.Router do
  use Plug.Router
  use Plug.ErrorHandler

  alias UrlRegister.Model

  require Logger

  plug(Plug.LoggerJSON, log: Logger.level())
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:dispatch)

  post "/visited_links" do
    {status, body} =
      case conn.body_params do
        %{"links" => links} ->
          Model.VisitedLinks.save_links(links)
          {200, Model.Status.encode("ok")}

        _ ->
          {422, Model.Status.encode("empty links list")}
      end

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, body)
  end

  get "/visited_domains" do
    {status, body} =
      case fetch_query_params(conn).query_params do
        %{"from" => from, "to" => to} ->
          domains = Model.VisitedDomains.get_domains(from, to)
          {200, Model.VisitedDomains.encode(domains, "ok")}

        _ ->
          send_resp(conn, 400, Model.Status.encode("missing params"))
      end

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, body)
  end

  match _ do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(404, Model.Status.encode("not found"))
  end

  defp handle_errors(%Plug.Conn{status: 500} = conn, %{
         kind: kind,
         reason: reason,
         stack: stacktrace
       }) do
    Plug.LoggerJSON.log_error(kind, reason, stacktrace)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(500, Model.Status.encode("internal error"))
  end

  defp handle_errors(_, _), do: nil
end
