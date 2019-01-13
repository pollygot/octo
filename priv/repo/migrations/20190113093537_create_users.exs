defmodule Octo.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :project_id, references(:projects, on_delete: :delete_all)

      timestamps()
    end

    create index(:users, [:project_id])
  end
end
