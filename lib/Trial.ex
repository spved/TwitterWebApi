defmodule Trial do
  def testingEngine() do
    IO.inspect :ets.whereis(:engineTable), label: "engineTableInTrial"
  end
end
