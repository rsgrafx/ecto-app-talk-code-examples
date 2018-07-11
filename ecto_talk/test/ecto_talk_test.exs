defmodule EctoTalkTest do
  use ExUnit.Case
  doctest EctoTalk

  test "greets the world" do
    assert EctoTalk.hello() == :world
  end
end
