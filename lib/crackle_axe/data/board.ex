defmodule CrackleAxe.Data.Board do
  alias __MODULE__.Entity
  use TypedStruct

  @type entity() :: nil | __MODULE__.Entity.id()

  typedstruct do
    field :name, String.t()
    field :board, list(list(entity()))
    field :active_entities, %{Entity.id() => Entity.t()}, default: %{}
  end

  @doc """
  Generates a new board struct.
  """
  @spec new(String.t(), pos_integer(), pos_integer()) :: t()
  def new(name, x, y) do
    %__MODULE__{name: name, board: board_gen(x, y)}
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

  @doc """
  Places the given object as an entity in the board.
  """
  @spec place_entity(t(), Entity.object_option(), non_neg_integer(), non_neg_integer()) ::
          {Entity.id(), t()}
  def place_entity(board, object, x, y) do
    entity = Entity.new(object, x, y)

    {entity.id,
     board
     |> Map.update!(:active_entities, &Map.put(&1, entity.id, entity))
     |> Map.update!(
       :board,
       &List.replace_at(&1, y, List.replace_at(Enum.at(&1, y), x, entity.id))
     )}
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
end
