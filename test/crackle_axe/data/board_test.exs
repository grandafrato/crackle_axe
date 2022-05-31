defmodule CrackleAxe.Data.BoardTest do
  alias CrackleAxe.Data.Board
  use ExUnit.Case, async: true

  describe "new/3" do
    setup do
      x = :rand.uniform(20)
      y = :rand.uniform(20)
      %Board{name: name, board: board} = Board.new("Foo", x, y)

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

  describe "String.Chars" do
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
  end

  defp board_rep_by(board, fun) do
    board_charlist = to_string(board) |> String.replace("\n", "") |> String.to_charlist()

    board.board
    |> List.flatten()
    |> Enum.zip(board_charlist)
    |> Enum.each(fun)
  end
end