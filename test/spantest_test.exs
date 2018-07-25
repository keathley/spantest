defmodule SpantestTest do
  use ExUnit.Case
  doctest Spantest

  test "greets the world" do
    assert Spantest.hello() == :world
  end
end
