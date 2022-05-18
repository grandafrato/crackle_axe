defmodule CrackleAxe.Data.Attributes do
  @type t() :: {%{atom() => fun()}, any()}
  @type attrs() :: %{atom() => t()}

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
      alias unquote(__MODULE__)
    end
  end

  @doc """
  An example of a basic attribute.
  """
  @spec basic() :: {:basic, {%{atom() => fun()}, boolean()}}
  def basic(), do: {:basic, {%{identity: & &1}, Integer.mod(Enum.random(1..100), 2) == 0}}

  @spec add_attribute(map(), {atom(), t()}) :: attrs()
  def add_attribute(map, {name, item}), do: Map.put(map, name, item)
end
