defmodule TwitterPheonixWeb.PageController do
  use TwitterPheonixWeb, :controller



    def index(conn, _params) do
      #IO.inspect _params, label: "_params"
      render(conn, "test.html")
    end

    def simulate(conn, _params) do
      #IO.inspect _params, label: "_params"
      render(conn, "simulate.html", numUsers: "")
    end

    def simulation(conn, %{"numUsers" => nUsers, "numTweets" => nTweets}) do

      IO.inspect nUsers, label: "nUsers"

      IO.inspect nTweets, label: "nTweets"
      #numTweets
      #IO.inspect _params, label: "_params"
      #TwitterPheonixWeb.Twitter.twitterStart(100,10)
      TwitterPheonixWeb.Twitter.twitterStart(String.to_integer(nUsers),String.to_integer(nTweets))
      render(conn, "simulate.html", numUsers: nUsers)
    end

    def displayText(conn, %{"userName" => tdata}) do
      #checking = IO.inspect tdata

      #engine = TwitterPheonixWeb.Twitter.Engine.start_node()
      #:ets.insert_new(engineTable, {"engineId", engine})

      #TwitterPheonixWeb.Twitter.Simulator.getEngine()

      IO.inspect "testing the Engine in pageController"
      Trial.testingEngine()
      IO.inspect "Done testing the Engine in pageController"

      TwitterPheonix.getEngineId()

      IO.inspect :ets.whereis(:users), label: "usingTry"

      IO.inspect :ets.whereis(:engineTable), label: "usingTry"

      [{ _ , engine}] = :ets.lookup(:engineTable, "engineId")

      allTweets = :ets.new(:allTweets, [:named_table,:public])
      :ets.insert_new(allTweets, {"harika", ["tweeting"]})
      :ets.insert_new(allTweets, {"varsha", ["tweetingAgain"]})


       [{ _ , list}] = :ets.lookup(allTweets, tdata)
       stringList = Enum.join(list, ", ")



       #user = TwitterPheonixWeb.Twitter.Simulator.Helper.generateUserId(i)
       pid = TwitterPheonixWeb.Twitter.Client.start_node()
       pwd = TwitterPheonixWeb.Twitter.Simulator.Helper.generatePassword(1)
       mail = TwitterPheonixWeb.Twitter.Simulator.Helper.generateMail(1)
       GenServer.call(pid, {:register, tdata, pwd, mail})
       GenServer.call(engine, {:login, tdata, pwd})


       TwitterPheonixWeb.Twitter.Engine.insertUser(engine, pid, tdata, pwd, mail)
       userPid = GenServer.call(engine,{:getUser, tdata})


      render(conn, "testTweet.html", [userName: tdata , table: userPid])
    end

    def show(conn, %{"id" => id}) do
      #user = Repo.get(User, id)
      #render(conn, "show.html", user: user)
      #userPid = GenServer.cast(deleteUser, {:getUserTable, tdata})

      render(conn, "test.html", name: id)

    end



      def showTweet(conn, %{"tweetData" => tweetData}) do
        #user = Repo.get(User, id)
        #render(conn, "show.html", user: user)
        stringList = []
        render(conn, "testTweet.html", [userName: tweetData , table: stringList])

    end
end
