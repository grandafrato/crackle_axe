defmodule CrackleAxe.Data.AttributesTest do
  use CrackleAxe.Data.Attributes
  use ExUnit.Case, async: true

  describe "basic attribute" do
    test "it is a tuple of its name, functions and state" do
      assert match?({:basic, {_functions, _state}}, basic())
    end

    test "basic function takes the state as an argument and returns it" do
      {:basic, {funs, state}} = basic()
      assert state == funs.identity.(state)
    end
  end

  test "add_attribute/2" do
    assert match?(%{basic: {_funs, _state}}, add_attribute(%{}, basic()))
  end
end
