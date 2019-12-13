defmodule TwitterPheonix.SubscribedTo do
  use Ecto.Schema

  schema "subscribedTo" do
          field :userId, :string, null: false
          field :subscribedToIds, {:array, :string}
        end
end
