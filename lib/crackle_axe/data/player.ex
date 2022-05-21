defmodule CrackleAxe.Data.Player do
  use CrackleAxe.Data.Attributes
  use TypedStruct

  typedstruct do
    field :attributes, Attributes.attrs(), default: []
  end

  @doc """
  Creates a new valid player struct.
  """
  @spec new() :: t()
  def new(),
    do: %__MODULE__{attributes: %{} |> add_attribute(basic()) |> add_attribute(health(100))}

  @doc """
  Reduces the player's health.
  """
  @spec damage(t(), integer) :: t()
  def damage(player, damage) do
    Map.update!(
      player,
      :attributes,
      &Map.update!(&1, :health, fn x -> apply_action(x, :change_by, [-damage]) end)
    )
  end

  @doc """
  Increase the player's health.
  """
  @spec heal(t(), integer) :: t()
  def heal(player, damage) do
    Map.update!(
      player,
      :attributes,
      &Map.update!(&1, :health, fn x -> apply_action(x, :change_by, [damage]) end)
    )
  end
end
