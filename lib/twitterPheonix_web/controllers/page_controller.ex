defmodule TwitterPheonixWeb.PageController do
  use TwitterPheonixWeb, :controller
  import Ecto.Query, only: [from: 2]
  alias TwitterPheonix.Repo
   plug :put_layout, false when action in [:showTweet]

    def index(conn, _params) do
      #IO.inspect _params, label: "_params"
      render(conn, "test.html")
    end

    def simulate(conn, _params) do
      #IO.inspect _params, label: "_params"
      Repo.delete_all(TwitterPheonix.TweetUser)
      Repo.delete_all(TwitterPheonix.Tweets)
      Repo.delete_all(TwitterPheonix.SubscribedTo)
      Repo.delete_all(TwitterPheonix.Subscribers)
      Repo.delete_all(TwitterPheonix.HashTagTweetMap)
      Repo.delete_all(TwitterPheonix.MentionedUserMap)
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


    def show(conn, %{"id" => id}) do

      render(conn, "test.html", name: id, message: "")

    end


    def redirectLogin(conn, _params) do
      #IO.inspect _params, label: "_params"
      render(conn, "test.html", name: "", message: "")
    end

    def loginUser(conn,  %{"userName" => userName, "password" => password}) do
      login = GenServer.call(TwitterPheonixWeb.Twitter.Engine,{:login, userName, password})
      IO.inspect login, label: "Can I log in? "
      if login do
        [userPid,_,_,_] = GenServer.call(TwitterPheonixWeb.Twitter.Engine,{:getUser, userName})
        tweetList = GenServer.call(userPid, {:getMyTweets})
        tweetList = Enum.join(tweetList, "\"\n\"")
        followingList1 = GenServer.call(TwitterPheonixWeb.Twitter.Engine,{:getSubscribersOf, userName})
        followingList1 = Enum.join(followingList1, "\"\n\"")
        tweetedList = []

         render(conn, "testTweet.html", [userName: userName , table: tweetList, yourTweets: tweetedList, following: followingList1])
        #tweetList = []
        #tweetedList = []
        #render(conn, "testTweet.html", [userName: userName , table: tweetList, yourTweets: tweetedList, following: ""])
      else
        render(conn, "test.html", name: "", message: "Invalid User Name or Password")
      end
    end

    def redirectRegister(conn,  _params) do
      #IO.inspect _params, label: "_params"

      render(conn, "testRegister.html", name: "")
    end

    def registerUser(conn,  %{"userName" => userName, "password" => password, "mail" => mail}) do
      #engine
      pid = TwitterPheonixWeb.Twitter.Client.start_node()
      #GenServer.cast(pid, {:setEngine, engine})
      TwitterPheonixWeb.Twitter.Engine.insertUser(pid, userName, password, mail)

      #GenServer.call(pid, {:register, userName, password, mail})
      #GenServer.call(engine, {:login, userName, password})

      tweetList = []
      tweetedList = []
      render(conn, "testTweet.html", [userName: userName , table: tweetList, yourTweets: tweetedList, following: ""])
    end

      def showTweet(conn, %{"userName" => userName, "tweetList" => tweetList, "followingList" => followingList, "tweetData" => tweetData}) do

       [userPid,_,_,_] = GenServer.call(TwitterPheonixWeb.Twitter.Engine,{:getUser, userName})
       GenServer.call(userPid,{:tweet, tweetData})
       tweetList = GenServer.call(userPid, {:getMyTweets})
       IO.inspect tweetList, label: "tweetList"
       tweetList = Enum.join(tweetList, "\"\n\"")
       followingList1 = GenServer.call(TwitterPheonixWeb.Twitter.Engine,{:getSubscribersOf, userName})
       IO.inspect followingList1, label: "followingList1"
       followingList1 = Enum.join(followingList1, "\"\n\"")
       tweetedList = []

        render(conn, "testTweet.html", [userName: userName , table: tweetList, yourTweets: tweetedList, following: followingList1])

    end

    def showFollowers(conn, %{"userName" => userName, "tweetList" => tweetList, "followingList" => followingList, "followerData" => followerData}) do
      GenServer.call(TwitterPheonixWeb.Twitter.Engine,{:addSubscriberOf, userName, followerData})
      followingList1 = GenServer.call(TwitterPheonixWeb.Twitter.Engine,{:getSubscribersOf, userName})
      IO.inspect followingList1, label: "followingList1"
      followingList1 = Enum.join(followingList1, "\"\n\"")
      [userPid,_,_,_] = GenServer.call(TwitterPheonixWeb.Twitter.Engine,{:getUser, userName})
      tweetList = GenServer.call(userPid, {:getMyTweets})
      IO.inspect tweetList, label: "tweetList"
      tweetList = Enum.join(tweetList, "\"\n\"")
      tweetedList = []
      render(conn, "testTweet.html", [userName: userName , table: tweetList, yourTweets: tweetedList, following: followingList1])
  end
end
