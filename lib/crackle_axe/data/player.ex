defmodule CrackleAxe.Data.Player do
  import CrackleAxe.Data.Attributes
  alias CrackleAxe.Data.Attributes
  use TypedStruct

  typedstruct do
    field :attributes, list(Attributes.t()), default: []
  end

  @spec new() :: t()
  def new(), do: %__MODULE__{attributes: [basic()]}
end
