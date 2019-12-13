defmodule TwitterPheonixWeb.Twitter do
  #use GenServer
  def twitterStart(numUsers, numTweets) do


      GenServer.call(TwitterPheonixWeb.Twitter.Engine, {:initDB})

      pid = TwitterPheonixWeb.Twitter.Client.start_node()


      clients =  Enum.map(1..numUsers, fn _ ->
            pid = TwitterPheonixWeb.Twitter.Client.start_node()

            GenServer.call(TwitterPheonixWeb.Twitter.Engine, {:insertUser, pid, "user", "passwd", "email"})
            GenServer.cast(pid, {:setEngine, TwitterPheonixWeb.Twitter.Engine})

            pid
          end)
         IO.inspect clients

      TwitterPheonixWeb.Twitter.Simulator.simulate(numUsers, numTweets, clients, TwitterPheonixWeb.Twitter.Engine)



    end



  def init(init_arg) do
    {:ok, init_arg}
  end

  def hello() do
    "world"
  end

end
