defmodule UrlRegister.Plugs.IncompleteRequestError do
  @moduledoc """
  Error raised when a required query parameters sre missing.
  """

  defexception message: "", plug_status: 400
end

defmodule UrlRegister.Plugs.VerifyQuery do
  def init(options), do: options

  def call(%Plug.Conn{request_path: path} = conn, opts) do
    if path in opts[:paths],
      do:
        UrlRegister.Plugs.Verifier.verify_request!(
          Plug.Conn.fetch_query_params(conn).query_params,
          opts[:query_params]
        )

    conn
  end
end

defmodule UrlRegister.Plugs.VerifyBody do
  def init(options), do: options

  def call(%Plug.Conn{request_path: path} = conn, opts) do
    if path in opts[:paths],
      do: UrlRegister.Plugs.Verifier.verify_request!(conn.body_params, opts[:body_params])

    conn
  end
end

defmodule UrlRegister.Plugs.Verifier do
  @spec verify_request!(map(), map()) :: nil
  def verify_request!(params, opts) do
    verified =
      params
      |> Map.keys()
      |> contains_params?(opts)

    unless verified, do: raise(UrlRegister.Plugs.IncompleteRequestError)
  end

  @spec contains_params?(list(), map()) :: boolean
  defp contains_params?(keys, opts), do: Enum.all?(opts, fn p -> p in keys end)
end
