defmodule TwitterPheonix.Repo.Migrations.CreateTweeterTables do
  use Ecto.Migration

  def change do
    create table(:tweetUsers) do
              add :name, :string, null: false
              add :pid, :string, null: false
              add :password, :string, null: false
              add :email, :string, null: false
              add :login, :integer, default: 0
    end
    create table(:tweets) do
              add :tweetId, :integer, null: false
              add :tweet, :string, null: false
    end
    create table(:subscribers) do
              add :userId, :string, null: false
              add :subscribersIds, {:array, :string}
    end

    create table(:subscribedTo) do
              add :userId, :string, null: false
              add :subscribedToIds, {:array, :string}
    end

    create table(:tweetUserMap) do
              add :userId, :string, null: false
              add :tweetIds, {:array, :integer}
    end

    create table(:hashTagTweetMap) do
              add :hashtag, :string, null: false
              add :tweetIds, {:array, :integer}
    end

    create table(:mentionedUserMap) do
              add :userId, :string, null: false
              add :tweetIds, {:array, :integer}
    end
  end
end
