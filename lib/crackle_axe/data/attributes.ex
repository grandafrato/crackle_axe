defmodule CrackleAxe.Data.Attributes do
  @type t() :: {atom(), %{atom() => fun()}, any()}

  @doc """
  An example of a basic attribute.
  """
  @spec basic() :: {:basic, %{atom() => fun()}, boolean()}
  def basic() do
    {:basic,
     %{
       print_hello_if_true: fn x ->
         if x do
           IO.puts("hello")
         end

         x
       end
     }, Integer.mod(Enum.random(1..100), 2) == 0}
  end
end
