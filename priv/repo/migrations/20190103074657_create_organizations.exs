defmodule Octo.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations) do
      add :name, :string
      add :admin_id, references(:customers, on_delete: :nothing)
    end

    execute "ALTER TABLE organizations ADD inserted_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP" # Automatically fill with the current date
    execute "ALTER TABLE organizations ADD updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP"
    execute "CREATE TRIGGER notify_organizations AFTER INSERT OR UPDATE ON organizations FOR EACH ROW EXECUTE PROCEDURE broadcast_changes();" # Trigger the pubsub procedure

  end
end
