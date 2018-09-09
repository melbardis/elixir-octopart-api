defmodule OctopartApiTest do
  use ExUnit.Case
  doctest OctopartApi

  test "greets the world" do
    assert OctopartApi.hello() == :world
  end
end
