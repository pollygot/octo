defmodule Octo.Repo.Migrations.CreateFlags do
  use Ecto.Migration

  def change do
    create table(:flags) do
      add :name, :string
      add :is_on, :boolean, default: false, null: false
      add :project_id, references(:projects, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:flags, [:name, :project_id])
  end
end
