defmodule OctopartApi do
  @moduledoc ~S"""
  Documentation for OctopartApi.

  ## OctopartApi Documentation


  Documentation for the various fields and queries available for Octopart, view the following links.
  Note the links redirect you to pages hosted by Octopart.com, do you may want to open them in another window.

  - [Overview](https://octopart.com/api/docs/v3/overview)
  - [Search Tutorial](https://octopart.com/api/docs/v3/search-tutorial)
  - [Rest API Reference](https://octopart.com/api/docs/v3/rest-api)

  ## URL arguments

    The API query string is build using an Elixir pipeline. For example:

  ```
  rsp =
    get(
      parts_search()
      |> q("solid state relay")
      |> filter_fields("brand.name", "Texas Instruments")
      |> filter_fields("offers.seller.name", "Digi-Key")
      |> start(0)
    )

    ```

    The following table lists functions used to generate each specific URL argument.
    Not all arguments apply to all endpoints, check the Octopart API docs on where to use.

   URL Argument |    Function
   ------------------------------ | -----------------
   `callback=""` | ```callback("name of callback function to wrap the result") ```
   `q=""` | ``` q("full text query string") ```
   `start=0` | ``` start("Orinal pos of first result, min 0, max 1000") ```
   `limit=10` | ``` limit("number results to return. default 10, max 100" ) ```
   `sortby="score desc"` | ``` sortby("Attribute (fieldname/fieldvalue) pair to filter results on") ```
   `filter[fields][<fieldname>][]=""` | ``` filter_fields("field-name", "string") ```
   `filter[queries][]=""` | ``` filter_queries("string") ```
   `facet[fields][<fieldname>][include]=false` | ``` facet_fields_include( "fieldname", boolean) ```
   `facet[fields][<fieldname>][exclude_filter]=false` | ``` facet_fields_exclude_filter( "fieldname", boolean) ```
   `facet[fields][<fieldname>][start]=0` | ``` facet_fields_start( "fieldname", integer 0...1000) ```
   `facet[fields][<fieldname>][limit]=10` | ``` facet_fields_limit( "fieldname", integer 10...100) ```
   `stats[<fieldname>][include]=false` | ``` stats_include( "fieldname", boolean ) ```
   `stats[<fieldname>][exclude_filter]=false` | ``` stats_exclude_filter( "fieldname", boolean ) ```



  """

  # third party
  # @require UriQuery
  require HTTPoison
  require Poison

  # ours
  # require OctopartApi.Endpoints.Brands
  # alias OctopartApi.Endpoints.Brands

  @root_category "8a1e4714bb3951d9"

  def hello() do
    :world
  end

  #############################################################################
  # URL arguments
  #############################################################################

  @doc ~S"""
    Append to query: ``` &q="callback string" ```
  """
  @spec callback(String.t(), String.t()) :: String.t()
  def callback(q, v) when is_binary(v) do
    q <> "&q=" <> URI.encode(v, &URI.char_unreserved?/1)
  end

  @doc ~S"""
    Append to query: ``` &q="query string" ```
  """
  @spec q(String.t(), String.t()) :: String.t()
  def q(q, v) when is_binary(v) do
    q <> "&q=" <> URI.encode(v, &URI.char_unreserved?/1)
  end

  @doc ~S"""
    Append to query: ``` &start=0```
  """
  @spec start(String.t(), integer) :: String.t()
  def start(q, v) when is_integer(v) do
    q <> "&start=" <> to_string(v)
  end

  @doc ~S"""
    Append to query: ``` &limit=10```
  """
  @spec limit(String.t(), integer) :: String.t()
  def limit(q, v) when is_integer(v) do
    q <> "&limit=" <> URI.encode(v)
  end

  @doc ~S"""
    Append to query: ``` &sortyby=<list of fields>" ```
  """

  @spec sortby(String.t(), String.t(), String.t()) :: String.t()
  def sortby(q, f, v) when is_binary(f) and is_binary(v) do
    q <> "&sortby=" <> URI.encode(v)
  end

  @doc ~S"""
    Append to query: ``` &filter[fields][<fieldname>][]="" ```
  """
  @spec filter_fields(String.t(), String.t(), String.t()) :: String.t()
  def filter_fields(q, f, v) when is_binary(f) and is_binary(v) do
    q <> "&filter[fields][" <> URI.encode(f) <> "]=" <> URI.encode(v)
  end

  @doc ~S"""
    Append to query: ``` &filter[queries][]="" ```
  """
  @spec filter_queries(String.t(), String.t()) :: String.t()
  def filter_queries(q, v) when is_binary(v) do
    q <> "&filter[queries][]=" <> URI.encode(v)
  end

  @doc ~S"""
    Append to query: ``` &facet[fields][<fieldname>][include]="" ```
  """
  @spec facet_fields_include(String.t(), String.t(), boolean) :: String.t()
  def facet_fields_include(q, f, v \\ false) when is_binary(f) and is_boolean(v) do
    q <> "&facet[fields][" <> URI.encode(f) <> "[include]=" <> URI.encode(v)
  end

  @doc ~S"""
    Append to query: ``` &facet[fields][<fieldname>][exclude_filter]="" ```
  """
  @spec facet_fields_exclude_filter(String.t(), String.t(), boolean) :: String.t()
  def facet_fields_exclude_filter(q, f, v \\ false) when is_binary(f) and is_boolean(v) do
    q <> "&facet[fields][" <> URI.encode(f) <> "[exclude_filter]=" <> URI.encode(v)
  end

  @doc ~S"""
    Append to query: ``` &facet[fields][<fieldname>][start]=0 ```
  """
  @spec facet_fields_start(String.t(), String.t(), integer) :: String.t()
  def facet_fields_start(q, f, v \\ 0) when is_binary(f) and is_integer(v) do
    if is_integer(v),
      do: q <> "&facet[fields][" <> URI.encode(f) <> "[start]=" <> URI.encode(v),
      else: throw("Expected integer")
  end

  @doc ~S"""
    Append to query: ``` &facet[fields][<fieldname>][limit]=10 ```
  """
  @spec facet_fields_limit(String.t(), String.t(), integer) :: String.t()
  def facet_fields_limit(q, f, v \\ 10) when is_binary(f) and is_integer(v) do
    if is_integer(v),
      do: q <> "&facet[fields][" <> URI.encode(f) <> "[limit]=" <> URI.encode(v),
      else: throw("Expected integer")
  end

  @doc ~S"""
    Append to query: ``` &facet[queries][]="" ```
  """
  @spec facet_queries(String.t(), String.t()) :: String.t()
  def facet_queries(q, v \\ "") when is_binary(v) do
    q <> "&facet[queries][]=" <> URI.encode(v)
  end

  @doc ~S"""
    Append to query: ``` &stats[<fieldname>][include]="" ```
  """
  @spec stats_include(String.t(), String.t(), boolean) :: String.t()
  def stats_include(q, f, v \\ false) when is_binary(f) and is_boolean(v) do
    q <> "stats[" <> URI.encode(f) <> "][include]=" <> URI.encode(v)
  end

  @doc ~S"""
    Append to query: ``` &stats[<fieldname>][exclude_filter]="" ```
  """
  @spec stats_exclude_filter(String.t(), String.t(), boolean) :: String.t()
  def stats_exclude_filter(q, f, v \\ false) when is_binary(f) and is_boolean(v) do
    q <> "stats[" <> URI.encode(f) <> "][exclude_filter]=" <> URI.encode(v)
  end

  #############################################################################
  # Endpoints
  #############################################################################

  # generate the base url along with any additional endpoint path, including the apikey
  defp mk_url(path) do
    Application.get_env(:octopart_api, :octopart_url) <>
      path <> "?apikey=" <> Application.get_env(:octopart_api, :apikey)
  end

  def brands_uid(uid), do: mk_url("/brands/" <> uid)
  def brands_search(), do: mk_url("/brands/search")
  def brands_get_multi(), do: mk_url("/brands/get_multi")

  def categories_uid(uid), do: mk_url("/categories/" <> uid)
  def categories_search(), do: mk_url("/categoriescategories/search")
  def categories_get_multi(), do: mk_url("/categories/get_multi")

  def parts_uid(uid), do: mk_url("/parts/" <> uid)
  def parts_match(), do: mk_url("/parts/match")
  def parts_search(), do: mk_url("/parts/search")
  def parts_get_multi(), do: mk_url("/parts/get_multi")

  def sellers_uid(uid), do: mk_url("/sellers/" <> uid)
  def sellers_search(), do: mk_url("/sellers/search")
  def sellers_get_multi(), do: mk_url("/sellers/get_multi")

  def get(req) do
    {:ok, rsp} = OctopartApi.RateServer.get(req)
    {:ok, json} = Poison.decode(rsp.body)
    #  IO.inspect(json)
    json
  end

  def x() do
    rsp =
      get(
        parts_search()
        |> q("solid state relay")
        |> filter_fields("brand.name", "Texas Instruments")
        |> filter_fields("offers.seller.name", "Digi-Key")
        |> start(0)
      )
  end
end
