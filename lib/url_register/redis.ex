defmodule UrlRegister.Redis do
  def get_domains(from, to) when is_binary(from) and is_binary(to) do
    Redix.command!(:redix, ["ZRANGEBYSCORE", "visited", "#{from}", "#{to}"])
  end

  def save_domains(query) when is_list(query) do
    Redix.command!(:redix, ["ZADD", "visited"] ++ query)
  end
end
