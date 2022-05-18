defmodule CrackleAxe.Data.AttributesTest do
  alias CrackleAxe.Data.Attributes
  use ExUnit.Case, async: true

  describe "basic attribute" do
    test "it is a tuple of its name, functions and state" do
      assert match?({:basic, _functions, _state}, Attributes.basic())
    end

    test "every function takes the state as an argument and returns a new one" do
      {:basic, funs, state} = Attributes.basic()
      assert [state] == Enum.map(funs, &elem(&1, 1).(state))
    end
  end
end
