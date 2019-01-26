defmodule Octo.Repo.Migrations.CreateCustomers do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add :name, :string, null: false
    end

    execute "ALTER TABLE customers ADD inserted_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP" # Automatically fill with the current date
    execute "ALTER TABLE customers ADD updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP"
    execute "CREATE TRIGGER notify_customers AFTER INSERT OR UPDATE ON customers FOR EACH ROW EXECUTE PROCEDURE broadcast_changes();" # Trigger the pubsub procedure
    
  end
end
