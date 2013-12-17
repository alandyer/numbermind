defmodule NumbermindTest do
  use ExUnit.Case

  test "the truth" do
    assert(true)
  end
  
  test "check win" do
    assert  Numbermind.compareGuess([1, 2, 3, 4], [3, 5, 6, 4]) == ["X", "O", "-", "-"]
  end
  
  test "check getRandomAnswerList size" do
    assert length(Numbermind.getRandomAnswerList(4)) == 4
  end
  
  test "check randomness of getRandomAnswerList" do
    assert Numbermind.getRandomAnswerList(1000) != Numbermind.getRandomAnswerList(1000)
  end
end
