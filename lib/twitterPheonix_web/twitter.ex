defmodule TwitterPheonixWeb.Twitter do
  use GenServer
  def twitterStart(numUsers, numTweets) do

      #engine = TwitterPheonixWeb.Twitter.Engine.start_node()
      #GenServer.call(engine, {:initDB})
     #IO.inspect engine
     GenServer.call(TwitterPheonixWeb.Twitter.Engine, {:initDB})
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

end
#TwitterPheonixWeb.Twitter.main(System.argv())
