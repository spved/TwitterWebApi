defmodule TwitterPheonixWeb.PageController do
  use TwitterPheonixWeb, :controller

   plug :put_layout, false when action in [:showTweet]

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

      render(conn, "loginRegister.html")
#      render(conn, "simulate.html", numUsers: nUsers)
    end

    def displayText(conn, %{"userName" => tdata}) do
      #checking = IO.inspect tdata

      #engine = TwitterPheonixWeb.Twitter.Engine.start_node()
      #:ets.insert_new(engineTable, {"engineId", engine})

      #TwitterPheonixWeb.Twitter.Simulator.getEngine()

      IO.inspect "testing the Engine in pageController"
      #Trial.testingEngine()
      IO.inspect "Done testing the Engine in pageController"

      #TwitterPheonix.getEngineId()

      #IO.inspect :ets.whereis(:users), label: "usingTry"

      #IO.inspect :ets.whereis(:engineTable), label: "usingTry"

      #[{ _ , engine}] = :ets.lookup(:engineTable, "engineId")

      allTweets = :ets.new(:allTweets, [:named_table,:public])
      :ets.insert_new(allTweets, {"harika", ["tweeting"]})
      :ets.insert_new(allTweets, {"varsha", ["tweetingAgain"]})


       #[{ _ , list}] = :ets.lookup(allTweets, tdata)
       #stringList = Enum.join(list, ", ")



       #user = TwitterPheonixWeb.Twitter.Simulator.Helper.generateUserId(i)

       #pid = TwitterPheonixWeb.Twitter.Client.start_node()
       #pwd = TwitterPheonixWeb.Twitter.Simulator.Helper.generatePassword(1)
       #mail = TwitterPheonixWeb.Twitter.Simulator.Helper.generateMail(1)
       #GenServer.call(pid, {:register, tdata, pwd, mail})
       #GenServer.call(engine, {:login, tdata, pwd})


       #TwitterPheonixWeb.Twitter.Engine.insertUser(engine, pid, tdata, pwd, mail)
       #userPid = GenServer.call(engine,{:getUser, tdata})

      stringList = []
      tweetedList = []
      render(conn, "testTweet.html", [userName: tdata , table: stringList, yourTweets: tweetedList])
    end

    def show(conn, %{"id" => id}) do

      render(conn, "test.html", name: id)

    end


    def redirectLogin(conn, _params) do
      #IO.inspect _params, label: "_params"
      render(conn, "test.html", name: "")
    end

    def loginUser(conn,  %{"userName" => userName, "password" => password}) do
      #engine

      #GenServer.call(engine, {:login, userName, password})

      # userPid = GenServer.call(eng,{:getUser, userName})

      # tweetList = GenServer.call(userPid,{:returnStateTweets})

      # tweetList = List.to_string(tweetList)

      #tweetedList = GenServer.call(engine,{:getTweetsOfUser, userName})

      # tweetedList = List.to_string(tweetedList)

      tweetList = []
      tweetedList = []
      render(conn, "testTweet.html", [userName: userName , table: tweetList, yourTweets: tweetedList])
    end

    def redirectRegister(conn,  _params) do
      #IO.inspect _params, label: "_params"

      render(conn, "testRegister.html", name: "")
    end

    def registerUser(conn,  %{"userName" => userName, "password" => password, "mail" => mail}) do
      #engine
      #pid = TwitterPheonixWeb.Twitter.Client.start_node()
      #GenServer.cast(pid, {:setEngine, engine})

      #GenServer.call(pid, {:register, userName, password, mail})
      #GenServer.call(engine, {:login, userName, password})

      tweetList = []
      tweetedList = []
      render(conn, "testTweet.html", [userName: userName , table: tweetList, yourTweets: tweetedList])
    end

      def showTweet(conn, %{"userName" => userName, "tweetList" => tweetList, "tweetData" => tweetData}) do

        tweetList = [tweetList] ++ [tweetData]
      #  eng = TwitterPheonixWeb.Twitter.Engine.start_node()


      # userPid = GenServer.call(eng,{:getUser, userName})

      # GenServer.cast(userPid,{:tweet, tweetData})


      # tweetList = GenServer.call(userPid,{:returnStateTweets})

      # tweetList = List.to_string(tweetList)

      #tweetedList = GenServer.call(engine,{:getTweetsOfUser, userName})

      # tweetedList = List.to_string(tweetedList)

      tweetedList = []

        render(conn, "testTweet.html", [userName: userName , table: tweetList, yourTweets: tweetedList])

    end
end
