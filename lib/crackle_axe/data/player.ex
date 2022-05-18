defmodule CrackleAxe.Data.Player do
  use CrackleAxe.Data.Attributes
  use TypedStruct

  typedstruct do
    field :attributes, Attributes.attrs(), default: []
  end

  @spec new() :: t()
  def new(), do: %__MODULE__{attributes: add_attribute(%{}, basic())}
end
