defmodule Octo.Repo.Migrations.CreateCustomersOrganizations do
  use Ecto.Migration

  def change do
    create table(:customers_organizations, primary_key: false) do
      add :customer_id, references(:customers, on_delete: :delete_all)
      add :organization_id, references(:organizations, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:customers_organizations, [:customer_id, :organization_id])
  end
end
