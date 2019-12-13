defmodule TwitterPheonix.HashTagTweetMap do
  use Ecto.Schema

  schema "hashTagTweetMap" do
          field :hashtag, :string, null: false
          field :tweetIds, {:array, :integer}
        end
end
