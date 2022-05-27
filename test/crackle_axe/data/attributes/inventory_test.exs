defmodule CrackleAxe.Data.Attributes.InventoryTest do
  alias CrackleAxe.Data.{Attributes.Inventory, Item}
  use ExUnit.Case, async: true

  test "it has the armor, storage, and hand fields" do
    assert match?(
             %Inventory{
               storage: nil,
               hand: %{
                 0 => nil,
                 1 => nil,
                 2 => nil,
                 3 => nil,
                 4 => nil,
                 5 => nil,
                 6 => nil,
                 7 => nil,
                 8 => nil,
                 9 => nil
               }
             },
             Inventory.new()
           )
  end

  test "hand/0 returns a 10 value map" do
    assert Inventory.hand() == %{
             0 => nil,
             1 => nil,
             2 => nil,
             3 => nil,
             4 => nil,
             5 => nil,
             6 => nil,
             7 => nil,
             8 => nil,
             9 => nil
           }
  end

  test "put_in_hand/3 puts the given item in the item slot of the hand" do
    item = Item.new("Foo")

    assert match?(
             %Inventory{hand: %{9 => ^item}},
             Inventory.put_in_hand(Inventory.new(), 9, item)
           )
  end

  test "drop_from_hand/2 replaces the value of the given slot with nil" do
    assert match?(
             %Inventory{hand: %{9 => nil}},
             Inventory.drop_from_hand(Inventory.new(), 9)
           )
  end
end
