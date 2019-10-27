defmodule UrlRegister.Model.Status do
  defstruct status: "ok"

  def encode(status) when is_binary(status) do
    Poison.encode!(%UrlRegister.Model.Status{status: status})
  end
end

defmodule UrlRegister.Model.VisitedLinks do
  defstruct links: []

  def save_links(links) when is_list(links) do
    cur_time = :os.system_time(:second)

    redis_query =
      links
      |> Enum.map(fn l -> URI.parse(l).host end)
      |> Enum.filter(fn l -> l != nil end)
      |> Enum.flat_map(fn l -> ["#{cur_time}", "#{l}"] end)

    Redix.command!(:redix, ["ZADD", "visited"] ++ redis_query)
  end
end

defmodule UrlRegister.Model.VisitedDomains do
  defstruct domains: [], status: "ok"

  def encode(domains, status) when is_list(domains) and is_binary(status) do
    Poison.encode!(%UrlRegister.Model.VisitedDomains{domains: domains, status: status})
  end

  def get_domains(from, to) when is_binary(from) and is_binary(to) do
    Redix.command!(:redix, ["ZRANGEBYSCORE", "visited", "#{from}", "#{to}"])
  end
end
