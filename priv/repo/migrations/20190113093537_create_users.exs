defmodule Octo.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :identifier, :string
      add :project_id, references(:projects, on_delete: :delete_all)
    end

    execute "ALTER TABLE users ADD inserted_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP" # Automatically fill with the current date
    execute "ALTER TABLE users ADD updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP"
    execute "CREATE TRIGGER notify_users AFTER INSERT OR UPDATE ON users FOR EACH ROW EXECUTE PROCEDURE broadcast_changes();" # Trigger the pubsub procedure

    create index(:users, [:project_id])
  end
end
