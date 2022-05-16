defmodule CrackleAxe.Data.Item do
  use TypedStruct

  typedstruct do
    field :name, String.t()
  end

  @spec new(String.t()) :: t()
  def new(name), do: %__MODULE__{name: name}
end
