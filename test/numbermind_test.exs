defmodule NumbermindTest do
  use ExUnit.Case

  test "the truth" do
    assert(true)
  end
  
  test "check win" do
    assert  Numbermind.checkwin([1, 2, 3, 4], [3, 5, 6, 4]) == ["-", "-", "O", "X"]
  end
end
