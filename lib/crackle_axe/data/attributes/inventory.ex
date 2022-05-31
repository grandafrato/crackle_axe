defmodule CrackleAxe.Data.Attributes.Inventory do
  alias CrackleAxe.Data.Item
  use TypedStruct

  @type hand_t() :: %{
          0 => Item.t() | nil,
          1 => Item.t() | nil,
          2 => Item.t() | nil,
          3 => Item.t() | nil,
          4 => Item.t() | nil,
          5 => Item.t() | nil,
          6 => Item.t() | nil,
          7 => Item.t() | nil,
          8 => Item.t() | nil,
          9 => Item.t() | nil
        }

  typedstruct do
    field :storage, list(Item.t())
    field :hand, hand_t()
  end

  @doc """
  Returns a new Inventory struct
  """
  @spec new() :: t()
  def new(), do: %__MODULE__{hand: hand()}

  # Hand Stuff

  @doc """
  Returns a blank hand.
  """
  @spec hand() :: hand_t()
  def hand() do
    %{
      0 => nil,
      1 => nil,
      2 => nil,
      3 => nil,
      4 => nil,
      5 => nil,
      6 => nil,
      7 => nil,
      8 => nil,
      9 => nil
    }
  end

  @doc """
  Puts the given object in the hand.
  """
  @spec put_in_hand(t(), pos_integer(), Item.t() | nil) :: t()
  def put_in_hand(inventory, slot, item) do
    Map.update!(inventory, :hand, &Map.put(&1, slot, item))
  end

  @doc """
  Replaces the given slot with nil.
  """
  @spec drop_from_hand(t(), pos_integer()) :: t()
  def drop_from_hand(inventory, slot) do
    put_in_hand(inventory, slot, nil)
  end
end
