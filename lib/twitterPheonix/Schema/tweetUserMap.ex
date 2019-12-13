defmodule TwitterPheonix.TweetUserMap do
  use Ecto.Schema

  schema "tweetUserMap" do
          field :userId, :string, null: false
          field :tweetIds, {:array, :integer}
        end
end
