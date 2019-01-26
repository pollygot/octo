defmodule Octo.Repo.Migrations.CreateUsersFlags do
  use Ecto.Migration

  def change do
    create table(:users_flags) do
      add :is_on, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :delete_all)
      add :flag_id, references(:flags, on_delete: :delete_all)
    end

    execute "ALTER TABLE users_flags ADD inserted_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP" # Automatically fill with the current date
    execute "ALTER TABLE users_flags ADD updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP"
    execute "CREATE TRIGGER notify_users_flags AFTER INSERT OR UPDATE ON users_flags FOR EACH ROW EXECUTE PROCEDURE broadcast_changes();" # Trigger the pubsub procedure
    
    create unique_index(:users_flags, [:user_id, :flag_id])
    create index(:users_flags, [:user_id])
    create index(:users_flags, [:flag_id])
  end
end
