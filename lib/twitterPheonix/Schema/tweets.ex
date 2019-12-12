defmodule TwitterPheonix.Tweets do
  use Ecto.Schema

  schema "tweets" do
    field :tweetId, :integer, null: false
    field :tweet, :string, null: false
  end
end
