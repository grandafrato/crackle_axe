defmodule CrackleAxe.Data.AttributesTest do
  use CrackleAxe.Data.Attributes
  use ExUnit.Case, async: true

  describe "Attributes API" do
    test "add_attribute/2" do
      assert match?(%{basic: {_funs, _state}}, add_attribute(%{}, basic()))
    end

    test "apply_action/3" do
      {:basic, {actions, state} = basic_action} = basic()

      assert apply_action(basic_action, :identity, []) == {actions, actions.identity.(state)}

      assert apply_action(basic_action, :opposite_identity, []) ==
               {actions, actions.opposite_identity.(state)}
    end
  end

  describe "basic attribute" do
    test "it is a tuple of its name, functions and state" do
      assert match?({:basic, {_functions, _state}}, basic())
    end

    test "identity function takes the state as an argument and returns it" do
      {:basic, {funs, state}} = basic()
      assert state == funs.identity.(state)
    end

    test "opposite_identity function takes the state as an argument and returns the opposite of it" do
      {:basic, {funs, state}} = basic()
      assert !state == funs.opposite_identity.(state)
    end
  end

  describe "health_attribute" do
    test "health/2 will generate a halth attr with the expected current/msx health" do
      assert match?({:health, {_funs, 73}}, health(100, 73))
    end

    test "health/1 is equal to health/2 with equal arguments" do
      number = Enum.random(0..100)

      assert health(number) == health(number, number)
    end

    test ":change_by will add or subtract the health level by the value given value" do
      {:health, {actions, _} = health_attr} = health(182)

      assert apply_action(health_attr, :change_by, [-2]) == {actions, 180}
    end

    test ":change_by will not excede the max value" do
      {:health, {actions, _} = health_attr} = health(182, 90)

      assert apply_action(health_attr, :change_by, [+190]) == {actions, 182}
    end

    test ":change_by will not go below the min value" do
      {:health, {actions, _} = health_attr} = health(182, 90)

      assert apply_action(health_attr, :change_by, [-190]) == {actions, 0}
    end
  end
end
