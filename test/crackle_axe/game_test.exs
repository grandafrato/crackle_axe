defmodule CrackleAxe.GameTest do
  alias CrackleAxe.Game
  alias CrackleAxe.Data.Board
  use ExUnit.Case, async: true

  setup do
    {:ok, pid} = Game.start_link()

    [game: pid]
  end

  test "the state is a %Game{} struct", %{game: game} do
    assert match?(%Game{}, :sys.get_state(game))
  end

  describe "generated game" do
    test "has a board", %{game: game} do
      assert match?(%Game{board: %Board{}}, :sys.get_state(game))
    end

    test "has a player id matching the player on the board", %{game: game} do
      %Game{player_id: id, board: board} = :sys.get_state(game)

      assert id == Board.get_entity(board, id).id
    end

    test "the player starts at the (0, 0)", %{game: game} do
      %Game{player_id: id, board: board} = :sys.get_state(game)

      coordinates = Board.get_entity(board, id) |> then(&{&1.x, &1.y})

      assert coordinates == {0, 0}
    end
  end

  describe "move_player/2" do
    test "will move the player :down", %{game: game} do
      Game.move_player(game, :down)

      %Game{player_id: id, board: board} = :sys.get_state(game)
      coordinates = Board.get_entity(board, id) |> then(&{&1.x, &1.y})

      assert coordinates == {0, 1}
    end

    test "will move the player :right", %{game: game} do
      Game.move_player(game, :right)

      %Game{player_id: id, board: board} = :sys.get_state(game)
      coordinates = Board.get_entity(board, id) |> then(&{&1.x, &1.y})

      assert coordinates == {1, 0}
    end

    test "will move the player :left", %{game: game} do
      Game.move_player(game, :down)
      Game.move_player(game, :right)

      %Game{player_id: id, board: board} = :sys.get_state(game)
      coordinates = Board.get_entity(board, id) |> then(&{&1.x, &1.y})

      assert coordinates == {1, 1}

      Game.move_player(game, :left)

      %Game{player_id: id, board: board} = :sys.get_state(game)
      coordinates = Board.get_entity(board, id) |> then(&{&1.x, &1.y})

      assert coordinates == {0, 1}
    end

    test "will move the player :up", %{game: game} do
      Game.move_player(game, :down)
      Game.move_player(game, :right)

      %Game{player_id: id, board: board} = :sys.get_state(game)
      coordinates = Board.get_entity(board, id) |> then(&{&1.x, &1.y})

      assert coordinates == {1, 1}

      Game.move_player(game, :up)

      %Game{player_id: id, board: board} = :sys.get_state(game)
      coordinates = Board.get_entity(board, id) |> then(&{&1.x, &1.y})

      assert coordinates == {1, 0}
    end
  end

  test "get_board/1 returns the game's board", %{game: game} do
    assert match?(%Board{}, Game.get_board(game))
  end
end
