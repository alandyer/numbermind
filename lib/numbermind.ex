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
    elementof(guess, answer) ->
      checkwin(rest, answer, digit + 1, ["O" | acc])
    true ->
      checkwin(rest, answer, digit + 1, ["-" | acc])
  end
end

def elementof(a, []) do
  :false
end
def elementof(a, [headof | mylist]) do
  if a == headof do
    :true
  else
    elementof(a, mylist)
  end
end 

end   
