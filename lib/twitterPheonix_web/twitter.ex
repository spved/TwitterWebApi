defmodule TwitterPheonixWeb.Twitter do
  #use GenServer
  def twitterStart(numUsers, numTweets) do
      IO.inspect "came1"
      #engine = TwitterPheonixWeb.Twitter.Engine.start_node()
      IO.inspect "came2"
      #TwitterPheonixWeb.Twitter.Supervisor.start_link([])
      GenServer.call(TwitterPheonixWeb.Twitter.Engine, {:initDB})
      IO.inspect "came3"
      #engine = TwitterPheonixWeb.Twitter.Engine.start_node()
      #engineString = IO.inspect(engine)
      #engineId = %Engine.Engine{engineId: engineString}
      #engineIdString = IO.inspect engineId
      #Engine.Repo.insert(engineIdString)

      #:ets.new(:engineTable, [:named_table,:public])
      IO.inspect "came4"
      #:ets.insert_new(:engineTable, {"engineId", engine})
      #IO.inspect :engineTable, label: "created"

      #GenServer.call(engine, {:initDB})
      #IO.inspect engine

      pid = TwitterPheonixWeb.Twitter.Client.start_node()
      IO.inspect TwitterPheonixWeb.Twitter.Engine, label: "Engine"
      IO.inspect pid, label: "pidpid"
      IO.puts "came6"
      #TwitterPheonixWeb.Twitter.Engine.insertUser(pid, "user", "passwd", "email")
      #GenServer.call(TwitterPheonixWeb.Twitter.Engine, {:insertUser, pid, "user", "passwd", "email"})


      clients =  Enum.map(1..numUsers, fn _ ->
            pid = TwitterPheonixWeb.Twitter.Client.start_node()
            #IO.inspect TwitterPheonixWeb.Twitter.Engine, label: "Engine"
            #IO.inspect pid, label: "pidpid"
            #IO.puts "came6"
            GenServer.call(TwitterPheonixWeb.Twitter.Engine, {:insertUser, pid, "user", "passwd", "email"})
            GenServer.cast(pid, {:setEngine, TwitterPheonixWeb.Twitter.Engine})
            #IO.puts "came7"
            #IO.inspect pid, label: "pidpid"
            pid
          end)
         IO.inspect clients
      #IO.puts "came5"
      TwitterPheonixWeb.Twitter.Simulator.simulate(numUsers, numTweets, clients, TwitterPheonixWeb.Twitter.Engine)

      #IO.inspect :ets.whereis(:users), label: "using"

    end



  def init(init_arg) do
    {:ok, init_arg}
  end

  def hello() do
    "world"
  end

end
#TwitterPheonixWeb.Twitter.main(System.argv())
