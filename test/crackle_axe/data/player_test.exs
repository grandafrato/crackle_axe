defmodule CrackleAxe.Data.PlayerTest do
  alias CrackleAxe.Data.Player
  use ExUnit.Case, async: true

  test "has the basic attribute" do
    player = Player.new()
    assert Enum.any?(player.attributes, fn {name, _funs, _state} -> name == :basic end)
  end
end
