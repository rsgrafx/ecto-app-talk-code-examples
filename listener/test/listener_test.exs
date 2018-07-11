defmodule ListenerTest do
  use ExUnit.Case
  doctest Listener

  test "greets the world" do
    assert Listener.hello() == :world
  end
end
