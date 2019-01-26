defmodule Octo.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :name, :string
      add :organization_id, references(:organizations, on_delete: :delete_all)
    end

    execute "ALTER TABLE projects ADD inserted_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP" # Automatically fill with the current date
    execute "ALTER TABLE projects ADD updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP"
    execute "CREATE TRIGGER notify_projects AFTER INSERT OR UPDATE ON projects FOR EACH ROW EXECUTE PROCEDURE broadcast_changes();" # Trigger the pubsub procedure
    
    create unique_index(:projects, [:name, :organization_id])
  end
end
