defmodule UrlRegister.RouterTest do
  use ExUnit.Case
  use Plug.Test

  alias UrlRegister.Router

  @from "1571000000"
  @to "1572000000"

  @opts Router.init([])

  test "add visited links" do
    conn =
      :post
      |> conn("/visited_links")
      |> put_body_params(%{"links" => ["http://ya.ru", "http://funbox.ru"]})
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
  end

  test "show visited domains" do
    conn =
      :get
      |> conn("/visited_domains?from=#{@from}&to=#{@to}")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200
  end

  test "returns 404" do
    conn =
      :get
      |> conn("/missing", "")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
  end

  defp put_body_params(conn, params) do
    %{conn | body_params: params}
  end
end
