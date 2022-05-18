defmodule CrackleAxe.Data.Item do
  use CrackleAxe.Data.Attributes
  use TypedStruct

  typedstruct do
    field :name, String.t()
    field :attributes, Attributes.attrs(), default: []
  end

  @spec new(String.t()) :: t()
  def new(name), do: %__MODULE__{name: name, attributes: add_attribute(%{}, basic())}
end
