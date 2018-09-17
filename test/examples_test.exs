defmodule OctopartApiExamples do
  use ExUnit.Case
  doctest OctopartApi
  import OctopartApi

  test "example /parts/uid" do
    rsp = get(parts_uid("103cdb613d20cffb"))

    c = rsp["__class__"]
    assert String.match?(c, ~r/Part/)
  end

  test "example /parts/search" do
    rsp =
      get(
        parts_search()
        |> q("solid state relay")
        |> filter_fields("brand.name", "Texas Instruments")
        |> filter_fields("offers.seller.name", "Digi-Key")
        |> start(0)
      )

    c = rsp["__class__"]
    assert String.match?(c, ~r/SearchResponse/)
  end
end
