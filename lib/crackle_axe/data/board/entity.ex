defmodule CrackleAxe.Data.Board.Entity do
  alias CrackleAxe.Data.{Player, Item}
  use TypedStruct

  @type id() :: String.t()

  @type object_option() :: nil | Player.t() | Item.t()

  typedstruct do
    field :id, String.t()
    field :x, non_neg_integer()
    field :y, non_neg_integer()
    # Calling it object, for lack of a better word.
    field :object, object_option()
  end

  @doc """
  Creates a new entity with a unique ID.
  """
  @spec new(object_option(), non_neg_integer(), non_neg_integer()) :: t()
  def new(object, x, y) do
    %__MODULE__{id: UUID.uuid4(), object: object, x: x, y: y}
  end

  @doc """
  Moves the entity by the given numbers.
  """
  @spec move(t(), integer(), integer()) :: t()
  def move(entity, x, y) do
    entity
    |> Map.update!(:x, &max(0, &1 + x))
    |> Map.update!(:y, &max(0, &1 + y))
  end
end
