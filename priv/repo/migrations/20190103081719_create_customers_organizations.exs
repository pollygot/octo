defmodule Octo.Repo.Migrations.CreateCustomersOrganizations do
  use Ecto.Migration

  def change do
    create table(:customers_organizations) do
      add :customer_id, references(:customers, on_delete: :delete_all)
      add :organization_id, references(:organizations, on_delete: :delete_all)
    end
    
    execute "ALTER TABLE customers_organizations ADD inserted_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP" # Automatically fill with the current date
    execute "ALTER TABLE customers_organizations ADD updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP"
    execute "CREATE TRIGGER notify_customers_organizations AFTER INSERT OR UPDATE ON customers_organizations FOR EACH ROW EXECUTE PROCEDURE broadcast_changes();" # Trigger the pubsub procedure

    create unique_index(:customers_organizations, [:customer_id, :organization_id])
    create index(:customers_organizations, [:customer_id])
    create index(:customers_organizations, [:organization_id])
  end
end
