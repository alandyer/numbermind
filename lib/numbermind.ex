defmodule Numbermind do

  def compareGuess(guess, answer) do
    compareGuess(guess, answer, []) |> Enum.sort |> Enum.reverse
  end
  
  def compareGuess([], answer, acc) do
    acc
  end
  def compareGuess(guess, answer, acc) do
    #IO.inspect("Comparing #{inspect guess} to #{inspect answer}") #debug
    {xList, xLessGuess, xLessAnswer} = getXList(guess, answer)
    {olist, olessGuess, olessAnswer} = getOList(xLessGuess, xLessAnswer)
    dashList = getDashList(length(olessAnswer))
    xList ++ olist ++ dashList
  end
  
  def getXList(guess, answer) do
    getXList(guess, answer, [], [], [])
  end
  def getXList([], [], xlist, xlessGuess, xlessAnswer) do
    {xlist, xlessGuess, xlessAnswer}
  end
  def getXList([guessHead | guess], [answerHead | answer], xlist, xlessGuess, xlessAnswer) do
    cond do
      guessHead == answerHead ->
        getXList(guess, answer, ["X" | xlist], xlessGuess, xlessAnswer)
      true ->
        getXList(guess, answer, xlist, [guessHead | xlessGuess], [answerHead | xlessAnswer])
    end
  end

  def getOList(guess, answer) do
    getOList(guess, answer, [], [])
  end
  def getOList([], answer, oList, olessGuess) do
    {oList, olessGuess, answer}
  end
  def getOList([guessHead | guess], answer, oList, olessGuess) do
    cond do
      Enum.member?(answer, guessHead) ->
        getOList(guess, removeFirst(guessHead, answer), ["O" | oList], olessGuess)
      true ->
        getOList(guess, answer, oList, olessGuess)
    end
  end
  def getDashList(size) when size <= 0 do
    []
  end
  def getDashList(size) do
    ["-" | getDashList(size - 1)]
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
    compareGuessVeryEasy(guess, answer, 1, [])
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
    input = String.strip(IO.gets("Would you like to play a game of Numbermind?[y/n] "))
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
    #IO.puts(:io.format("Answer is ~p", [answer]))
    maxGuesses = 10
    results = guessLoop(answer, maxGuesses, [], [])
  end
  
  def guessLoop(answer, guessesLeft, guesses, results) do
    cond do
      guessesLeft <= 0 ->
        IO.puts(:io.format("Answer was ~p", [answer])) 
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
