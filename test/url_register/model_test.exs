defmodule UrlRegister.ModelTest do
  use ExUnit.Case

  alias UrlRegister.Model

  test "get domains from links" do
    assert Model.VisitedDomains.domains_from_links([
             "http://ya.ru",
             "https://moikrug.ru/vacancies?q=elixir",
             "https://github.com/issues?page=1&q=is%3Aopen+is%3Aissue+language%3Ago+label%3A%22good+first+issue%22&utf8=%E2%9C%93"
           ]) ==
             ["ya.ru", "moikrug.ru", "github.com"]
  end

  test "domains to store" do
    domains = ["ya.ru", "moikrug.ru", "github.com"]

    from_store =
      domains
      |> Model.VisitedDomains.domains_to_store()
      |> Enum.drop(1)
      |> Enum.take_every(2)
      |> Model.VisitedDomains.domains_from_store()

    assert domains == from_store
  end
end
