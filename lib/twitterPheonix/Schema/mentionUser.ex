defmodule TwitterPheonix.MentionedUserMap do
  use Ecto.Schema

  schema "mentionedUserMap" do
          field :userId, :string, null: false
          field :tweetIds, {:array, :integer}
        end
end
