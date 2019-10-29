defmodule UrlRegister.Model do
  defmodule Status do
    defstruct status: "ok"

    @spec encode(String.t()) :: iodata | no_return
    def encode(status) when is_binary(status) do
      Poison.encode!(%Status{status: status})
    end
  end

  defmodule VisitedDomains do
    defstruct domains: [], status: "ok"

    @spec encode(list(), String.t()) :: iodata | no_return
    def encode(domains, status) when is_list(domains) and is_binary(status) do
      Poison.encode!(%VisitedDomains{domains: domains, status: status})
    end

    @spec domains_from_links(list()) :: list()
    def domains_from_links(links) when is_list(links) do
      links
      |> Enum.map(fn l -> URI.parse(l).host end)
      |> Enum.filter(fn l -> l != nil end)
    end

    @spec domains_to_store(list()) :: list()
    def domains_to_store(domains) when is_list(domains) do
      cur_time = :os.system_time(:second)
      Enum.flat_map(domains, fn l -> ["#{cur_time}", "#{l}:#{cur_time}"] end)
    end

    @spec domains_from_store(list()) :: list()
    def domains_from_store(data) when is_list(data) do
      data
      |> Enum.map(fn d -> String.slice(d, 0..-12) end)
      |> Enum.uniq()
    end
  end
end
