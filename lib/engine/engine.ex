defmodule Engine.Engine do
  use Ecto.Schema

  schema "engineTable" do
    field :engineId, :string
  end
end
