defmodule OctopartApiExamples do
  use ExUnit.Case
  doctest OctopartApi
  import OctopartApi
  import Logger

  defp log(json) do
    if ExUnit.configuration()[:trace],
      do: IO.inspect(json, label: "\n\n-------------------------------------------\n")
  end

  # -----------------------------------------------------------------------------
  # Brands
  # -----------------------------------------------------------------------------

  test("example /brands/uid") do
    rsp = get(brands_uid("2239e3330e2df5fe"))
    log(rsp)
  end

  test "example /brands/search" do
    rsp =
      get(
        brands_search()
        |> q("texas")
        |> start(0)
        |> limit(5)
      )

    log(rsp)
  end

  test "example /brands/get_multi" do
    rsp =
      get(
        brands_get_multi()
        |> uid(["2239e3330e2df5fe", "c4f105fbe7591336"])
      )

    log(rsp)
  end

  # -----------------------------------------------------------------------------
  # Categories
  # -----------------------------------------------------------------------------
  test("example /categories/uid") do
    rsp = get(categories_uid("87a44aaeb6be5c63"))
    log(rsp)
  end

  test "example /categories/search" do
    rsp =
      get(
        categories_search()
        |> q("semiconductors")
        |> start(0)
        |> limit(5)
      )

    log(rsp)
  end

  test "example /categories/get_multi" do
    rsp =
      get(
        categories_get_multi()
        |> uid(["3b27f62d0a3ae0e0", "9e07530daf1645c0"])
      )

    log(rsp)
  end

  # -----------------------------------------------------------------------------
  # Parts
  # -----------------------------------------------------------------------------

  test("example /parts/uid") do
    rsp = get(parts_uid("103cdb613d20cffb"))
    log(rsp)
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

    log(rsp)
  end

  test "example /parts/match" do
    rsp =
      get(
        parts_match()
        |> queries([
          %{mpn: "SN74S74N", reference: "line1"},
          %{sku: "67K1122", reference: "line2"},
          %{mpn_or_sku: "SN74S74N", reference: "line3"},
          %{mpn: "SN74S74N", brand: "Texas Instruments", reference: "line4"}
        ])
      )

    log(rsp)
  end

  test "example /parts/get_multi" do
    rsp =
      get(
        parts_get_multi()
        |> uid(["103cdb613d20cffb", "2a68e3620f0cf5af"])
      )

    log(rsp)
  end

  # -----------------------------------------------------------------------------
  # Sellers
  # -----------------------------------------------------------------------------

  test("example /sellers/uid") do
    rsp = get(sellers_uid("d294179ef2900153"))
    log(rsp)
  end

  test "example /sellers/search" do
    rsp =
      get(
        sellers_search()
        |> q("newark")
        |> start(0)
        |> limit(5)
      )

    log(rsp)
  end

  test "example /sellers/get_multi" do
    rsp =
      get(
        sellers_get_multi()
        |> uid(["d294179ef2900153", "2c3be9310496fffc"])
      )

    log(rsp)
  end
end
