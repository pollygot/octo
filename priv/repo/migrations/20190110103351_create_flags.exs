defmodule Octo.Repo.Migrations.CreateFlags do
  use Ecto.Migration

  def change do
    create table(:flags) do
      add :name, :string
      add :is_on, :boolean, default: false, null: false
      add :project_id, references(:projects, on_delete: :delete_all)
    end

    execute "ALTER TABLE flags ADD inserted_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP" # Automatically fill with the current date
    execute "ALTER TABLE flags ADD updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP"
    execute "CREATE TRIGGER notify_flags AFTER INSERT OR UPDATE ON flags FOR EACH ROW EXECUTE PROCEDURE broadcast_changes();" # Trigger the pubsub procedure
    
    create unique_index(:flags, [:name, :project_id])
  end
end
