defmodule Octo.Repo.Migrations.AddFieldToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :identifier, :string
    end
  end
end
