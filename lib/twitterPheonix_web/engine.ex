defmodule TwitterPheonixWeb.Twitter.Engine do
  use GenServer
  import Ecto.Query, only: [from: 2]
  alias TwitterPheonix.Repo
  #all set functions are cast and all get funtions are call

  def insertUser(engine, pid, user, passwd, email) do
   GenServer.call(engine, {:insertUser, pid, user, passwd, email})
  end

  def deleteUser(engine, pid) do
   GenServer.cast(engine, {:deleteUser, pid})
  end

  def deleteTweet(engine, tweetId) do
   GenServer.cast(engine, {:deleteTweet, tweetId})
  end

  #login/logout

  def handle_call({:login,userName, password}, _from, state) do
    {users,_,_,_,_,_,_,_} = state
    loggedIn = if TwitterPheonixWeb.Twitter.Helper.validateUser(userName) do
      list = TwitterPheonixWeb.Twitter.Helper.readValue(:ets.lookup(users, userName))
      userPassword = Enum.at(list, 1)
      #query = from(p in TwitterPheonix.TweetUser,
      #        select: p.name, p.password, p.email
      #        where: p.name = userName)
      user = Repo.get_by(TwitterPheonix.TweetUser, name: userName)
      #IO.inpspect user, label: "UserData"
      loggedIn = if userPassword == password do
        :ets.insert(users, {userName, List.replace_at(list, 3, 1)})
        true
      else
        false
      end
      loggedIn
    end
    {:reply, loggedIn, state}
  end

  def handle_call({:logout, userName}, _from, state) do
    {users,_,_,_,_,_,_,_} = state
    if TwitterPheonixWeb.Twitter.Helper.validateUser(userName) do
      list = TwitterPheonixWeb.Twitter.Helper.readValue(:ets.lookup(users, userName))
      :ets.insert(users, {userName, List.replace_at(list, 3, 0)})
    end
    {:reply,:ok, state}
  end

  def handle_call({:insertUser, pid, user, passwd, email}, _from, state) do
    {users,_,_,_,_,_,_,_} = state
    if !TwitterPheonixWeb.Twitter.Helper.validateUser(user) do
    #IO.inspect :ets.lookup(users, "user3")
      :ets.insert_new(users, {user, [pid, passwd,email,0]})
    end
    {:ok, inserted} = Repo.insert(%TwitterPheonix.TweetUser{name: user, pid: "1234", password: passwd, email: email})
    #IO.inspect inserted, label: "Inserted User"
    {:reply, :ok, state}
  end

  def handle_call({:getUser, userName}, _from, state) do
    {users,_,_,_,_,_,_,_} = state
      list = TwitterPheonixWeb.Twitter.Helper.readValue(:ets.lookup(users, userName))
      #query = from p in TwitterPheonix.TweetUser,
      #        select: p.name, p.password, p.email
      #        where: p.name = userName
      #Repo.all(query)
    {:reply,list, state}
  end

  #insert and get tweet
  def handle_call({:getTweet, tweetId}, _from, state) do
    #tweet = List.first(TwitterPheonixWeb.Twitter.Helper.readValue(:ets.lookup(tweets, tweetId)))
    data = Repo.get_by(TwitterPheonix.Tweets, id: tweetId)
    tweet = if is_nil(data) do
      nil
    else
      data.tweet
    end
    IO.inspect tweet, label: "tweet found"
    {:reply, tweet, state}
  end

  def handle_call({:addTweet, tweet}, _from, state) do
    #{_,tweets,_,_,_,_,_,tableSize} = state
    #id = :ets.update_counter(tableSize, "tweets", {2,1})
    #:ets.insert_new(tweets, {id, [tweet, 0]})
    {:ok, inserted} = Repo.insert(%TwitterPheonix.Tweets{tweetId: 1, tweet: tweet})
    id = inserted.id
    IO.inspect id, label: "------id inserted------>"
    #IO.inspect inserted, label: "Inserted Tweet"
    {:reply, id, state}
  end

  #subscribers table insert_new, insert, get
  def handle_call({:getSubscribers, user}, _from, state) do
    {_,_,subscribers,_,_,_,_,_} = state
    list = TwitterPheonixWeb.Twitter.Helper.readValue(:ets.lookup(subscribers, user))
    {:reply, list, state}
  end


  #subscribedTo table insert_new, insert, get
  def handle_call({:getSubscribersOf, user}, _from, state) do
    {_,_,_,subscribedTo,_,_,_,_} = state
    list = TwitterPheonixWeb.Twitter.Helper.readValue(:ets.lookup(subscribedTo, user))
    {:reply, list, state}
  end

  #tweetUserMap table insert_new, insert, get
  def handle_call({:getTweetsOfUser, user}, _from, state) do
    {_,_,_,_,tweetUserMap,_,_,_} = state
    list = TwitterPheonixWeb.Twitter.Helper.readValue(:ets.lookup(tweetUserMap, user))
    {:reply, list, state}
  end





  #mentionUserMap table insert_new, insert, get
  def handle_call({:getMentionedTweets, user}, _from, state) do
    {_,_,_,_,_,mentionUserMap,_,_} = state
    list = TwitterPheonixWeb.Twitter.Helper.readValue(:ets.lookup(mentionUserMap, user))
    {:reply, list, state}
  end

  #hashTagTweetMap table insert_new, insert, get
  def handle_call({:getHashTagTweets, hashTag}, _from, state) do
    {_,_,_,_,_,_,hashTagTweetMap,_} = state
    list = TwitterPheonixWeb.Twitter.Helper.readValue(:ets.lookup(hashTagTweetMap, hashTag))
    {:reply, list, state}
  end

  def handle_call({:print}, _from, state) do
    {users, _, subscribers, subscribedTo, tweetUserMap, mentionUserMap, hashTagTweetMap, _} = state

    IO.inspect users, label: "users"
    IO.inspect subscribers, label: "subscribers"
    IO.inspect subscribedTo, label: "subscribedTo"
    IO.inspect tweetUserMap, label: "tweetUserMap"
    IO.inspect mentionUserMap, label: "mentionUserMap"
    IO.inspect hashTagTweetMap, label: "hashTagTweetMap"
    {:reply, :ok, state}
  end

  def handle_call({:initDB}, _from, _) do
    users = if :ets.whereis :user == :undefined do
      :ets.new(:users, [:named_table,:public])
    else
      :ets.whereis :user
    end
    #tweets = :ets.new(:tweets, [:named_table,:public])
    subscribers = :ets.new(:subscribers, [:named_table,:public])
    subscribedTo = :ets.new(:subscribedTo, [:named_table,:public])
    tweetUserMap = :ets.new(:tweetUserMap, [:named_table,:public])
    mentionUserMap = :ets.new(:mentionUserMap, [:named_table,:public])
    tableSize = :ets.new(:tableSize, [:named_table,:public])
    hashTagTweetMap = :ets.new(:hashTagTweetMap, [:named_table,:public])

    :ets.insert_new(tableSize, {"tweets", 0})

    state = {users, users, subscribers, subscribedTo, tweetUserMap, mentionUserMap, hashTagTweetMap, tableSize}
    {:reply, :ok, state}
  end

  def handle_cast({:addTweetsToUser, user, tweetId}, state) do
    {_,_,_,_,tweetUserMap,_,_,_} = state
    list = TwitterPheonixWeb.Twitter.Helper.readValue(:ets.lookup(tweetUserMap, user))
    if list == [] do
      {:ok, inserted} = Repo.insert(%TwitterPheonix.TweetUserMap{userId: user, tweetIds: [tweetId]})
      #IO.inspect inserted, label: "Inserted User"
      :ets.insert_new(tweetUserMap, {user, [tweetId]})
    else
      :ets.insert(tweetUserMap, {user, list++[tweetId]})
    end
    {:noreply, state}
  end

  def handle_cast({:deleteUser, user}, state) do
    :ets.delete(:users, user)
    {:noreply, state}
  end

  def handle_cast({:deleteTweet, tweetId}, state) do
    Repo.delete_all(TwitterPheonix.Tweets, id: tweetId)
    {:noreply, state}
  end

  def handle_cast({:addHashTagTweet, hashTag, tweetId}, state) do
    #{_,_,_,_,_,_,hashTagTweetMap,_} = state
    list = TwitterPheonixWeb.Twitter.Helper.readValue(:ets.lookup(:hashTagTweetMap, hashTag))
    if list == [] do
      :ets.insert_new(:hashTagTweetMap, {hashTag, [tweetId]})
      {:ok, inserted} = Repo.insert(%TwitterPheonix.HashTagTweetMap{hashtag: hashTag, tweetIds: [tweetId]})
      #IO.inspect inserted, label: "Inserted Tweet"
    else
      :ets.insert(:hashTagTweetMap, {hashTag, list++[tweetId]})
    end
    {:noreply, state}
  end
   #Functions for testing simulator

   def handle_cast({:getUserTable, _}, state) do
    {_,_,_,_,_,_,_,_} = state
    #IO.inspect pid
    #IO.inspect :ets.lookup(:users, userName), label: "userDetails"
    {:noreply, state}
  end

  def handle_cast({:addSubscriberOf, user, suser}, state) do
    {_,_,_,subscribedTo,_,_,_,_} = state
    list = TwitterPheonixWeb.Twitter.Helper.readValue(:ets.lookup(subscribedTo, user))
    if list == [] do
      :ets.insert_new(subscribedTo, {user, [suser]})
    else
    list = list ++ [suser]
    list = Enum.uniq(list)
      :ets.insert(subscribedTo, {user, list})
    end
    {:noreply, state}
  end

  def handle_cast({:retweet, tweetId}, state) do
    #tweet = TwitterPheonixWeb.Twitter.Helper.readValue(:ets.lookup(:tweets, tweetId))
    #if tweet == [] do
    #else
      #tweetData = List.first(tweet)
    #end
    {:noreply, state}
  end

  def handle_cast({:send, userName, tweet}, state) do
    {users,_,subscribers,_,_,_,_,_} = state
    # {_,_,subscribers,_,_,_,_,_} = state

      currentList = TwitterPheonixWeb.Twitter.Helper.readValue(:ets.lookup(subscribers, userName))
      #currentList = GenServer.call(self(),{:getSubscribers, userName})
      #for each subscriber get tweets
      Enum.map(currentList, fn ni ->
          if TwitterPheonixWeb.Twitter.Helper.validateUser(ni) do
            pid = List.first(TwitterPheonixWeb.Twitter.Helper.readValue(:ets.lookup(users, ni)))
            GenServer.cast(pid, {:receive, ni, userName, tweet})
          end
      end)

    {:noreply, state}
  end

  def handle_cast({:addSubscriber, user, suser}, state) do
    {_,_,subscribers,_,_,_,_,_} = state
    list = TwitterPheonixWeb.Twitter.Helper.readValue(:ets.lookup(subscribers, user))
    if list == [] do
      :ets.insert_new(subscribers, {user, [suser]})
    else
    list = list ++ [suser]
    list = Enum.uniq(list)
      :ets.insert(subscribers, {user, list})
    end
    {:noreply, state}
  end

  def handle_cast({:addMentionedTweet, user, tweetId}, state) do
    {_,_,_,_,_,mentionUserMap,_,_} = state
    list = TwitterPheonixWeb.Twitter.Helper.readValue(:ets.lookup(mentionUserMap, user))
    if list == [] do
      :ets.insert_new(mentionUserMap, {user, [tweetId]})
    else
      :ets.insert(mentionUserMap, {user, list++[tweetId]})
    end
    {:noreply, state}
  end

  def start_node() do
    {:ok, pid} = GenServer.start_link(__MODULE__, :ok, [])
    GenServer.call(pid, {:initDB})
    pid
  end

  def init(:ok) do
  # {hashId, neighborMap} , {hashId, neighborMap}
  {:ok, 0}
  end
end
