defmodule Octo.Repo.Migrations.CreateUsersFlags do
  use Ecto.Migration

  def change do
    create table(:users_flags) do
      add :is_on, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :delete_all)
      add :flag_id, references(:flags, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:users_flags, [:user_id, :flag_id])
    create index(:users_flags, [:user_id])
    create index(:users_flags, [:flag_id])
  end
end
