defmodule Numbermind do

  def compareGuess(guess, answer) do
    compareGuess(guess, answer, 1, []) |> Enum.sort |> Enum.reverse
  end
  
  def compareGuess([], answer, digit, acc) do
    acc
  end
  def compareGuess([guess|rest], answer, digit, acc) do
    cond do
      guess == Enum.at(answer, digit - 1) ->
        compareGuess(rest, removeFirst(guess, answer), digit, ["X" | acc])
      Enum.member?(answer, guess) ->
        compareGuess(rest, removeFirst(guess, answer), digit, ["O" | acc])
      true ->
        compareGuess(rest, answer, digit + 1, ["-" | acc])
    end
  end
  
  def removeFirst(element, collection) do
    removeFirst(element, collection, []) |> Enum.reverse
  end
  defp removeFirst(element, [], acc) do
    acc
  end
  defp removeFirst(element, [hat | tail], acc) do
    cond do
      element == hat ->
        removeFirstAppendRest(tail, acc)
      true ->
        removeFirst(element, tail, [hat | acc])
    end
  end
  defp removeFirstAppendRest([], acc) do
    acc
  end
  defp removeFirstAppendRest([hat | tail], acc) do
    removeFirstAppendRest(tail, [hat|acc])
  end
      

  def compareGuessVeryEasy(guess, answer) do
    compareGuess(guess, answer, 1, [])
  end

  def compareGuessVeryEasy([], answer, digit, acc) do
    Enum.reverse(acc)
  end
  def compareGuessVeryEasy([guess | rest], answer, digit, acc) do
    cond do
      guess == Enum.at(answer, digit - 1) ->
        compareGuessVeryEasy(rest, answer, digit + 1, ["X" | acc])
      Enum.member?(answer, guess) ->
        compareGuessVeryEasy(rest, answer, digit + 1, ["O" | acc])
      true ->
        compareGuessVeryEasy(rest, answer, digit + 1, ["-" | acc])
    end
  end

  def mainLoop() do
    :random.seed(:erlang.now())
    input = String.strip(IO.gets("Would you like to play a game of Numbermind? "))
    cond do
      input == :eof ->
        IO.puts("System Encountered an error during input")
      input == {:error, Reason} ->
        IO.puts("System Encountered an error during input")
      true ->
        response = String.downcase(input)
        cond do
          response == "n" or response == "no" or response == "no." or response == "q" or response == "quit" ->
            IO.puts("Goodbye!")
          response == "yes" or response == "y" or response == "yes." ->
            newGame()
            mainLoop()
          true ->
            IO.puts("Unknown input, try again.")
            mainLoop()
        end
    end
  end

  def newGame() do
    answer = getRandomAnswerList(4)
    maxGuesses = 10
    results = guessLoop(answer, maxGuesses, [], [])
  end
  
  def guessLoop(answer, guessesLeft, guesses, results) do
    cond do
      guessesLeft <= 0 ->
        {:loss, :maxGuessesReached}
      true ->
        newGuessRaw = String.strip(IO.gets("What is your guess? "))
        newGuess = String.codepoints(newGuessRaw) |> Enum.map(fn(x) -> binary_to_integer(x) end)
        guessResult = compareGuess(newGuess, answer)
        cond do
          Enum.member?(guesses, newGuess) ->
            IO.puts("Guess already used, try again")
            guessLoop(answer, guessesLeft, guesses, results)
          guessResult == ["X", "X", "X", "X"] ->
            IO.puts(guessResult)
            :win
          true ->
            IO.puts(guessResult)
            Enum.zip([newGuess | guesses], [guessResult | results]) |> Stream.map(fn(x) -> IO.puts(x) end)
            guessLoop(answer, guessesLeft - 1, [newGuess | guesses], [guessResult | results])
        end
    end
  end

  def getRandomAnswerList(size) do
    Stream.repeatedly(fn -> :random.uniform(10) - 1 end) |> Enum.take size
  end

end   
