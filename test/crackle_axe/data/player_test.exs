defmodule CrackleAxe.Data.PlayerTest do
  alias CrackleAxe.Data.Player
  use ExUnit.Case, async: true

  test "has the basic attribute" do
    player = Player.new()
    assert Enum.any?(player.attributes, fn {name, {_funs, _state}} -> name == :basic end)
  end

  describe "Player Health" do
    test "has health attribute" do
      player = Player.new()
      assert Map.get(player.attributes, :health) != nil
    end

    test "damage/2 reduces player health by the amount given" do
      player = Player.new()
      assert match?(%Player{attributes: %{health: {_, 90}}}, Player.damage(player, 10))
    end

    test "heal/2 reduces player health by the amount given" do
      player = Player.new()

      assert match?(
               %Player{attributes: %{health: {_, 94}}},
               player |> Player.damage(10) |> Player.heal(4)
             )
    end
  end
end
