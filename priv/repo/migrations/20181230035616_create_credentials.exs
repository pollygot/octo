defmodule Octo.Repo.Migrations.CreateCredentials do
  use Ecto.Migration

  def change do
    create table(:credentials) do
      add :email, :string, null: false
      add :password_hash, :string, null: false
      add :customer_id, references(:credentials, on_delete: :delete_all, null: false)
    end
    
    execute "ALTER TABLE credentials ADD inserted_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP" # Automatically fill with the current date
    execute "ALTER TABLE credentials ADD updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP"
    execute "CREATE TRIGGER notify_credentials AFTER INSERT OR UPDATE ON credentials FOR EACH ROW EXECUTE PROCEDURE broadcast_changes();" # Trigger the pubsub procedure
    

    create unique_index(:credentials, [:email])
  end
end
