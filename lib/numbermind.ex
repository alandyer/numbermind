defmodule Numbermind do

  def checkwin(guess, answer) do
    checkwin(guess, answer, 1, [])
  end

  def checkwin([], answer, digit, acc) do
    Enum.reverse(acc)
  end
  def checkwin([guess | rest], answer, digit, acc) do
    cond do
      guess == Enum.at(answer, digit - 1) ->
        checkwin(rest, answer, digit + 1, ["X" | acc])
      Enum.member?(answer, guess) ->
        checkwin(rest, answer, digit + 1, ["O" | acc])
      true ->
        checkwin(rest, answer, digit + 1, ["-" | acc])
    end
  end

  def getRandomAnswerList(size) do
    Stream.repeatedly(fn -> :random.uniform(10) - 1 end) |> Enum.take size
  end

end   
