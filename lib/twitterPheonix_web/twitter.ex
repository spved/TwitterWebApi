defmodule TwitterPheonixWeb.Twitter do
  use GenServer
  def twitterStart(numUsers, numTweets) do

      engine = TwitterPheonixWeb.Twitter.Engine.start_node()


      :ets.new(:engineTable, [:named_table,:public])
      :ets.insert_new(:engineTable, {"engineId", engine})
      IO.inspect :engineTable, label: "created"

      #GenServer.call(engine, {:initDB})
      #IO.inspect engine
      clients =  Enum.map(1..numUsers, fn _ ->
            pid = TwitterPheonixWeb.Twitter.Client.start_node()
            GenServer.cast(pid, {:setEngine, engine})
            pid
          end)
         #IO.inspect clients

      TwitterPheonixWeb.Twitter.Simulator.simulate(numUsers, numTweets, clients, engine)

      IO.inspect :ets.whereis(:users), label: "using"

    end

  

  def init(init_arg) do
    {:ok, init_arg}
  end

  def hello() do
    "world"
  end

end
#TwitterPheonixWeb.Twitter.main(System.argv())
