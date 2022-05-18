defmodule CrackleAxe.Data.ItemTest do
  alias CrackleAxe.Data.Item
  use ExUnit.Case, async: true

  test "Items have names" do
    assert match?(%Item{name: "robob"}, Item.new("robob"))
  end

  test "has the basic attribute" do
    item = Item.new("Ye")
    assert Enum.any?(item.attributes, fn {name, {_funs, _state}} -> name == :basic end)
  end
end
