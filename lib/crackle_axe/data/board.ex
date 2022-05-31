defmodule CrackleAxe.Data.Board do
  alias CrackleAxe.Data.{Player, Item}
  use TypedStruct

  @type entity() :: nil | Player.t() | Item.t()

  typedstruct do
    field :name, String.t()
    field :board, list(list(entity()))
  end

  @doc """
  Generates a new board struct.
  """
  @spec new(String.t(), pos_integer(), pos_integer()) :: t()
  def new(name, x, y) do
    %__MODULE__{name: name, board: board_gen(x, y)}
  end

  defimpl String.Chars do
    @spec to_string(CrackleAxe.Data.Board.t()) :: String.t()
    def to_string(board) do
      Enum.map(board.board, fn row ->
        row
        |> Enum.map(fn entity ->
          case entity do
            nil -> ?\s
            :wall -> ?#
          end
        end)
        |> List.to_string()
      end)
      |> Enum.join("\n")
    end
  end

  defp board_gen(x, y) do
    1..(x * y)
    |> Enum.map(&wall_or_nil/1)
    |> Enum.chunk_every(x)
  end

  defp wall_or_nil(x) do
    if Integer.mod(x, 5) == 0 || Integer.mod(x, 3) == 0 do
      :wall
    else
      nil
    end
  end
end
