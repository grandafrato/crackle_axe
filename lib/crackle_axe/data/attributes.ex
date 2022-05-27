defmodule CrackleAxe.Data.Attributes do
  @type t() :: {%{atom() => fun()}, any()}
  @type attrs() :: %{atom() => t()}

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
      alias unquote(__MODULE__)
    end
  end

  # Attributes API

  @doc """
  Takes a map and a tuple with the key and item and inserts them into it.
  """
  @spec add_attribute(%{} | attrs(), {atom(), t()}) :: attrs()
  def add_attribute(map, {name, item}), do: Map.put(map, name, item)

  @spec apply_action(t(), atom(), list(any())) :: t()
  def apply_action({actions, state}, action, args) do
    {actions, apply(Map.get(actions, action), [state | args])}
  end

  # Attributes

  @doc """
  An example of a basic attribute.
  """
  @spec basic() :: {:basic, {%{atom() => fun()}, boolean()}}
  def basic(),
    do:
      {:basic,
       {%{identity: & &1, opposite_identity: &(!&1)}, Integer.mod(Enum.random(1..100), 2) == 0}}

  @doc """
  The attribute the measures health level.
  """
  @spec health(non_neg_integer(), non_neg_integer()) ::
          {:health, {%{atom() => fun()}, non_neg_integer()}}
  def health(max_health, current_health) do
    {:health, {%{change_by: &max(0, min(max_health, &1 + &2))}, current_health}}
  end

  @spec health(non_neg_integer()) :: {:health, {%{atom() => fun()}, non_neg_integer()}}
  def health(max_health), do: health(max_health, max_health)

  @doc """
  The inventory attribute.
  """
  @spec inventory() :: {:inventory, {%{atom() => fun()}, __MODULE__.Inventory.t()}}
  def inventory() do
    alias __MODULE__.Inventory
    {:inventory, {%{}, Inventory.new()}}
  end
end
