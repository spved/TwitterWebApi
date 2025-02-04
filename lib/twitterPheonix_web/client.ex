defmodule TwitterPheonixWeb.Twitter.Client do
  use GenServer

  def register(client, username,password,email) do
    GenServer.call(client, {:register, username,password,email})
  end

  def handle_call({:register,username,password,email}, _from, state) do
      {_,engine, tweetList} = state
      TwitterPheonixWeb.Twitter.Engine.insertUser(engine, self(), username, password, email)
      state = {username, engine, tweetList}
      {:reply, username, state}
  end

   def handle_cast({:delete,user}, state) do

     {userName,engine, tweetList} = state
     GenServer.cast(engine, {:deleteUser, userName})
     #:ets.delete(:users, username)
     tweetList = GenServer.call(engine,{:getTweetsOfUser, userName})
    Enum.each(tweetList, fn(tweet) ->
      GenServer.cast(engine, {:deleteTweet, tweet})
    end)
     state = {userName, engine, tweetList}
    #Process.exit(self(), :normal)
     {:noreply, state}
    end

  def handle_call({:querySubscribedTo}, _from, state) do
  {userName,engine, _} = state
   currentList = GenServer.call(engine,{:getSubscribers, userName})
   #IO.inspect currentList, label: "querySubscribedTo, currentList"
    #for each subscriber get tweets
    subscribedTweets = List.flatten(Enum.map(currentList, fn ni ->
          tweetList = GenServer.call(engine,{:getTweetsOfUser, ni})
          #IO.inspect tweetList, label: "tweets of user"
           #get tweets for each tweet id
           stweets = Enum.map(tweetList, fn n ->
           stweet = GenServer.call(engine, {:getTweet, n})
            stweet
          end)
       end))
      #IO.inspect subscribedTweets, label: "subscribedTweets"
       subscribedTweets
       {:reply, subscribedTweets, state}
    end

    def handle_cast({:tweet, tweetData}, state) do
        {userName,engine, _} = state
        GenServer.cast(engine, {:send, userName, tweetData})
        tweetId = GenServer.call(engine,{:addTweet,tweetData})
        GenServer.cast(engine, {:addTweetsToUser, userName, tweetId})
        #tweetId = TwitterPheonixWeb.Twitter.Helper.addTweet(tweetData,tweets,tableSize)
        TwitterPheonixWeb.Twitter.Helper.readTweet(tweetData,tweetId, engine)
        {:noreply, state}
    end

    def handle_cast({:reTweet, tweetId, tweetData}, state) do
        {userName,engine, _} = state
        #def handle_cast({:send, userName, tweet, subscribers, users}, state) do
        GenServer.cast(engine,{:retweet, tweetId})
        GenServer.cast(engine,{:send, userName, tweetData})
        #TwitterPheonixWeb.Twitter.Client.send(userName, tweetData, subscribers, users)
        {:noreply, state}
    end
#helper functions


  def handle_call({:queryHashTags, hashTag}, _from, state) do
    {userName,engine, _} = state
     currentList = GenServer.call(engine,{:getHashTagTweets, hashTag})
  #  currentList = TwitterPheonixWeb.Twitter.Helper.readValue(:ets.lookup(hashTagTweetMap, hashTag))
      htweets = List.flatten(Enum.map(currentList, fn ni ->
           tweet = GenServer.call(engine,{:getTweet, ni})
           tweet
         end))
      {:reply, htweets, state}
  end

  def handle_call({:queryMentions}, _from, state) do
  {userName,engine, _} = state
  currentList = GenServer.call(engine,{:getMentionedTweets, userName})
   # currentList = TwitterPheonixWeb.Twitter.Helper.readValue(:ets.lookup(mentionUserMap, userId))
    mtweets = List.flatten(Enum.map(currentList, fn ni ->
           tweet = GenServer.call(engine,{:getTweet, ni})
           #tweet = TwitterPheonixWeb.Twitter.Helper.readValue(:ets.lookup(tweets,ni))
           tweet
         end))
    {:reply, mtweets, state}
  end

  def handle_cast({:receive, userName, tweetUser, tweet}, state) do
    {user, engine, tweets} = state
    tweets = if TwitterPheonixWeb.Twitter.Helper.isLogin(userName, engine) == 1 do

      tweets
    else
      tweets++[tweet]
    end
    state = {user, engine, tweets}

    {:noreply, state}
  end

  def handle_call({:getUserName}, _from, state) do
    {userName,_, _} = state
    {:reply, userName, state}
  end

  def handle_cast({:subscribe, user1, userId2}, state) do
    {userId1 ,engine, _} = state
    #userId1 is subscribing to userId2
    #IO.inspect :ets.lookup(subscribers, userId2)
    GenServer.cast(engine,{:addSubscriber, userId1, userId2})
    GenServer.cast(engine,{:addSubscriberOf, userId2, userId1})
    #GenServer.cast({:addSubscriberOf, user, suser}, state) do
   #:ets.update_counter(subscribedTo, userId1, user2Subscribers )
   {:noreply, state}
  end

  def handle_call({:loginUser, passwd}, _from, state) do
    {user, engine, tweets} = state
    loggedIn = GenServer.call(engine, {:login, user, passwd})
    rtweets = if loggedIn do
      state = {user, engine, []}
      tweets
    else
      []
    end
    {:reply, rtweets, state}
  end

  def handle_call({:logoutUser}, _from, state) do
    {user, engine, tweets} = state
    GenServer.call(engine, {:logout, user})
    {:reply, :ok, state}
  end
  # testing functions

   def handle_call({:returnStateTweets}, _from, state) do
      {_,_,tweetList} = state
      IO.inspect tweetList, label: "returnStateTweets"
      {:reply, tweetList, state}
   end

   def handle_cast({:getUserTable, pid}, state) do
    {userName,engine, _} = state
    #{users,_,_,_,_,_,_,_} = state
    GenServer.cast(engine, {:getUserTable, userName})
    #IO.inspect :ets.lookup(:users, pid)
    {:noreply, state}
  end

  def handle_call({:getSubscribersOf, userName}, _from, state) do
    {_, engine, tweetList} = state
    GenServer.call(engine, {:getSubscribersOf, userName})
    state = {userName, engine, tweetList}
    {:reply, userName, state}
  end


  def handle_call({:setUserName, userName}, _from, state) do
    {_, engine, tweetList} = state
    state = {userName, engine, tweetList}
    {:reply, userName, state}
  end


  def handle_cast({:setEngine, engine}, state) do
    {userName,_, tweetList} = state
    state = {userName, engine, tweetList}
    {:noreply, state}
  end

  def start_node(args) do
    {:ok, _} = GenServer.start_link(__MODULE__, :ok, name: String.to_atom(args))
    #String.to_atom(args)
  end

  def init(:ok) do
  # {hashId, neighborMap} , {hashId, neighborMap}
  {:ok, {0, [],[]}}
  end

end
