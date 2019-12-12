defmodule TwitterPheonix.TweetUser do
  use Ecto.Schema

  schema "tweetUsers" do
    field :name, :string, null: false
    field :pid, :string, null: false
    field :password, :string, null: false
    field :email, :string, null: false
    field :login, :integer, default: 0
  end
end
