defmodule TwitterPheonixWeb.PageController do
  use TwitterPheonixWeb, :controller
  import Ecto.Query, only: [from: 2]
  alias TwitterPheonix.Repo

    def index(conn, _params) do
      Repo.delete_all(TwitterPheonix.TweetUser)
      Repo.delete_all(TwitterPheonix.Tweets)
      Repo.delete_all(TwitterPheonix.SubscribedTo)
      Repo.delete_all(TwitterPheonix.Subscribers)
      Repo.delete_all(TwitterPheonix.HashTagTweetMap)
      Repo.delete_all(TwitterPheonix.MentionedUserMap)

      TwitterPheonixWeb.Twitter.twitterStart(10,10)
      render(conn, "index.html")
    end

    def displayText(conn, _params) do
      render(conn, "index.html")
    end

    def show(conn, %{"id" => id}) do
      #user = Repo.get(User, id)
      #render(conn, "show.html", user: user)
      name = "VRASHAKHS"
      render(conn, "test.html", name: id)

    end
end
