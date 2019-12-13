defmodule TwitterPheonix.Subscribers do
  use Ecto.Schema

  schema "subscribers" do
          field :userId, :string, null: false
          field :subscribersIds, {:array, :string}
        end
end
