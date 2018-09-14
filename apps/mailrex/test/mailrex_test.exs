defmodule MailrexTest do
  use ExUnit.Case
  doctest Mailrex

  test "greets the world" do
    assert Mailrex.hello() == :world
  end
end
