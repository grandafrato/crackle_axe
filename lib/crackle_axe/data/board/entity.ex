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

  @spec new(object_option(), non_neg_integer(), non_neg_integer()) :: t()
  def new(object, x, y) do
    %__MODULE__{id: UUID.uuid4(), object: object, x: x, y: y}
  end
end
