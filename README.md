# OctopartApi

Elixir client for the Octopart API.

In development!


## OctopartApi Documentation

Documentation for the various fields and queries available for Octopart, view the following links:

- [Overview](https://octopart.com/api/docs/v3/overview)
- [Search Tutorial](https://octopart.com/api/docs/v3/search-tutorial)
- [Rest API Reference](https://octopart.com/api/docs/v3/rest-api)



## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `octopart_api` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:octopart_api, "~> 0.1.0"}
  ]
end
```
## Before User

1) register with octopart.com and obtain an api key. This is required to gain access to their database.
Note: access is rate limited to 3 requests/second. Money can overcome this limitation.
2) define an environment variable "OCTOPART_APIKEY=<your api key from step 1>"




Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/octopart_api](https://hexdocs.pm/octopart_api).
