defmodule TwitterPheonix.Repo.Migrations.TableEngine do
  use Ecto.Migration

  def change do
    create table(:engineTable) do
      add :engineId, :string
    end
  end
end
