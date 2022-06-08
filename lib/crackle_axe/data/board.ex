defmodule CrackleAxe.Data.Board do
  alias __MODULE__.Entity
  use TypedStruct

  @type entity() :: nil | :wall | Entity.id()

  typedstruct do
    field :name, String.t()
    field :board, list(list(entity()))
    field :active_entities, %{Entity.id() => Entity.t()}, default: %{}
    field :width, pos_integer()
    field :height, pos_integer()
  end

  @doc """
  Generates a new board struct.
  """
  @spec new(String.t(), pos_integer(), pos_integer()) :: t()
  def new(name, x, y) do
    %__MODULE__{name: name, board: board_gen(x, y), width: x, height: y}
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
       &board_replace(&1, entity.id, x, y)
     )}
  end

  @doc """
  Moves an entity from one place to another on the board.
  """
  @spec move_entity(t(), Entity.id(), integer(), integer()) :: t()
  def move_entity(board, id, x, y) do
    board
    |> Map.update!(
      :active_entities,
      &Map.update!(&1, id, fn entity ->
        Entity.move(entity, min(board.width - 1, x), min(board.height - 1, y))
      end)
    )
    |> then(fn updated_board ->
      Map.update!(updated_board, :board, fn board_data ->
        board_data
        |> board_replace(nil, board.active_entities[id].x, board.active_entities[id].y)
        |> board_replace(
          id,
          updated_board.active_entities[id].x,
          updated_board.active_entities[id].y
        )
      end)
    end)
  end

  defp board_replace(board_data, item, x, y) do
    List.replace_at(board_data, y, List.replace_at(Enum.at(board_data, y), x, item))
  end

  @doc """
  Returns the entity identifier of the entity at the given coordinates.
  """
  @spec entity_id_at(t(), non_neg_integer(), non_neg_integer()) :: nil | entity()
  def entity_id_at(board, x, y) do
    Enum.at(Enum.at(board.board, y), x)
  end

  @doc """
  Returns an entity by its id.
  """
  @spec get_entity(t(), Entity.id()) :: Entity.t() | :error
  def get_entity(board, id) do
    Map.fetch!(board.active_entities, id)
  end

  defdelegate to_string(board), to: String.Chars.CrackleAxe.Data.Board

  defimpl String.Chars do
    @spec to_string(CrackleAxe.Data.Board.t()) :: String.t()
    def to_string(board) do
      Enum.map(board.board, fn row ->
        row
        |> Enum.map(fn entity ->
          case entity do
            nil -> ?\s
            :wall -> ?#
            _ -> ?@
          end
        end)
        |> List.to_string()
      end)
      |> Enum.join("\n")
    end
  end
end
