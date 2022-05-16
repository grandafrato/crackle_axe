defmodule CrackleAxe.Data.ItemTest do
  alias CrackleAxe.Data.Item
  use ExUnit.Case, async: true

  test "Items have names" do
    assert %Item{name: "robob"} == Item.new("robob")
  end
end
