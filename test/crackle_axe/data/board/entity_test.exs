defmodule CrackleAxe.Data.Board.EntityTest do
  alias CrackleAxe.Data.{Board.Entity, Player, Item}
  use ExUnit.Case, async: true

  describe "new/3" do
    test "it returns an entity with a valid UUID" do
      entity = Entity.new(nil, 0, 0)

      assert match?({:ok, _}, UUID.info(entity.id))
    end

    test "it contains the thing it encapsulates" do
      object = Enum.random([Player.new(), Item.new("Foo")])
      entity = Entity.new(object, 0, 0)

      assert entity.object == object
    end

    test "it contains the given coordinates" do
      {x, y} = {:rand.uniform(20), :rand.uniform(20)}
      entity = Entity.new(nil, x, y)

      assert {entity.x, entity.y} == {x, y}
    end
  end
end
