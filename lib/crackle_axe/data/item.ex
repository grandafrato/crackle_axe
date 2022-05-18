defmodule CrackleAxe.Data.Item do
  import CrackleAxe.Data.Attributes
  alias CrackleAxe.Data.Attributes
  use TypedStruct

  typedstruct do
    field :name, String.t()
    field :attributes, list(Attributes.t()), default: []
  end

  @spec new(String.t()) :: t()
  def new(name), do: %__MODULE__{name: name, attributes: [basic()]}
end
