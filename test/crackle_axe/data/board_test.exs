defmodule CrackleAxe.Data.BoardTest do
  alias CrackleAxe.Data.{Board, Player}
  use ExUnit.Case, async: true

  describe "new/3" do
    setup do
      {x, y} = {:rand.uniform(18) + 2, :rand.uniform(18) + 2}

      %Board{name: name, board: board, active_entities: %{}, width: ^x, height: ^y} =
        Board.new("Foo", x, y)

      [board: board, name: name, x: x, y: y]
    end

    test "it creates a new board filled with nil", context do
      assert context.name == "Foo"
      assert Enum.count(context.board) == context.y
      assert Enum.all?(context.board, &(Enum.count(&1) == context.x))
    end

    test "it creates a board populated only with either nil or :wall", context do
      assert Enum.all?(context.board, fn x -> Enum.all?(x, &(&1 == nil || &1 == :wall)) end)
    end

    test "it generates a board with some :wall values", context do
      assert Enum.any?(context.board, &Enum.any?(&1, fn x -> x == :wall end))
    end

    test "it generates a board with some nil values", context do
      assert Enum.any?(context.board, &Enum.any?(&1, fn x -> x == nil end))
    end
  end

  describe "place_entity/4" do
    test "it puts the entity in a map of active entities, accessable by the ID" do
      {id, updated_board} = Board.place_entity(Board.new("Foo", 10, 10), Player.new(), 4, 3)

      assert Map.has_key?(updated_board.active_entities, id)
      assert id == Map.get(updated_board.active_entities, id).id
    end

    test "it makes the x and y in active_entities equal to both indexes to reach it's board id" do
      {id, %Board{active_entities: entities, board: board_data}} =
        Board.place_entity(Board.new("Test Equal", 10, 10), Player.new(), 4, 3)

      assert Enum.at(
               Enum.at(board_data, Map.get(entities, id).y),
               Map.get(entities, id).x
             ) == id
    end
  end

  describe "move_entity/4" do
    setup do
      {x, y} = {:rand.uniform(18) + 2, :rand.uniform(18) + 2}
      {id, board} = Board.new("Foo", x, y) |> Board.place_entity(Player.new(), 0, 0)

      [board: board, player_id: id]
    end

    test "will not move entities past board boundries", %{board: board, player_id: player_id} do
      updated_board0 = Board.move_entity(board, player_id, 100, 100)
      updated_board1 = Board.move_entity(board, player_id, -2, -2)

      assert Map.get(updated_board0.active_entities, player_id).x == board.width - 1
      assert Map.get(updated_board0.active_entities, player_id).y == board.height - 1

      assert Map.get(updated_board1.active_entities, player_id).x == 0
      assert Map.get(updated_board1.active_entities, player_id).y == 0
    end

    test "will have the coordinates of the entity be equal to the position on the board", %{
      board: board,
      player_id: player_id
    } do
      updated_board = Board.move_entity(board, player_id, 1, 1)

      assert Board.entity_id_at(updated_board, 1, 1) == player_id
    end
  end

  test "entity_id_at/3 returns the entity identifier at the coordinates on the board" do
    {x, y} = {:rand.uniform(9), :rand.uniform(9)}
    {id, board} = Board.new("Foo", 10, 10) |> Board.place_entity(Player.new(), x, y)

    assert Board.entity_id_at(board, x, y) == id
  end

  test "get_entity/2 returns the entity by id" do
    {x, y} = {:rand.uniform(9), :rand.uniform(9)}
    {id, board} = Board.new("Foo", 10, 10) |> Board.place_entity(Player.new(), x, y)

    assert Board.get_entity(board, id) == board.active_entities[id]
  end

  describe "to_string/1" do
    test "to_string/1 is equal to String.Chars.CrackleAxe.Board.to_string/1" do
      board = Board.new("Foo", 10, 10)

      assert to_string(board) == Board.to_string(board)
    end

    test "represents nil with a space" do
      board = Board.new("Foo", 10, 10)

      board_rep_by(board, fn {entity, char} ->
        if entity == nil do
          assert char == ?\s
        end
      end)
    end

    test "represents :wall with #" do
      board = Board.new("Foo", 10, 10)

      board_rep_by(board, fn {entity, char} ->
        if entity == :wall do
          assert char == ?#
        end
      end)
    end

    test "represents an entity with @" do
      {x, y} = {:rand.uniform(9), :rand.uniform(9)}
      {_, board} = Board.new("Foo", 10, 10) |> Board.place_entity(Player.new(), x, y)

      board_rep_by(board, fn {entity, char} ->
        if match?({:ok, _}, UUID.info(entity)) do
          assert char == ?@
        end
      end)
    end
  end

  defp board_rep_by(board, fun) do
    board_charlist = to_string(board) |> String.replace("\n", "") |> String.to_charlist()

    board.board
    |> List.flatten()
    |> Enum.zip(board_charlist)
    |> Enum.each(fun)
  end
end
