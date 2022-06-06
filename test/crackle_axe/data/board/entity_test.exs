defmodule CrackleAxe.Data.Board.EntityTest do
  alias CrackleAxe.Data.{Board.Entity, Player, Item}
  use ExUnit.Case, async: true

  describe "new/3" do
    test "returns an entity with a valid UUID" do
      entity = Entity.new(nil, 0, 0)

      assert match?({:ok, _}, UUID.info(entity.id))
    end

    test "contains the thing it encapsulates" do
      object = Enum.random([Player.new(), Item.new("Foo")])
      entity = Entity.new(object, 0, 0)

      assert entity.object == object
    end

    test "contains the given coordinates" do
      {x, y} = {:rand.uniform(20), :rand.uniform(20)}
      entity = Entity.new(nil, x, y)

      assert {entity.x, entity.y} == {x, y}
    end
  end

  describe "move/3" do
    test "updates the coordinates by the given numbers" do
      {x, y} = {:rand.uniform(20), :rand.uniform(20)}
      # Subtracting y from x and vice-versa
      %Entity{x: new_x, y: new_y} = Entity.new(nil, x, y) |> Entity.move(-y, -x)

      assert new_x == x - y || new_x == 0
      assert new_y == y - x || new_y == 0
    end

    test "will not move the entity into negative coordinates" do
      %Entity{x: new_x, y: new_y} = Entity.new(nil, 2, 2) |> Entity.move(-4, -4)

      assert new_x == 0
      assert new_y == 0
    end
  end
end
