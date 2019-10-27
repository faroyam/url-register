# UrlRegister

This application tracks URL visits and gathers the data to Redis.

## Installation

The package can be installed by adding `url_register` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:url_register, "~> 0.1.0"}
  ]
end
```

Or you can git clone it and run via `mix run --no-halt`.
It is necessary to start Redis, e.g. [`docker-compose up -d`](docker-compose.yml)

## API specs

[swagger](api/swagger.yml)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
