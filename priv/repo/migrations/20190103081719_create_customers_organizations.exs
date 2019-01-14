defmodule Octo.Repo.Migrations.CreateCustomersOrganizations do
  use Ecto.Migration

  def change do
    create table(:customers_organizations) do
      add :customer_id, references(:customers, on_delete: :delete_all)
      add :organization_id, references(:organizations, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:customers_organizations, [:customer_id, :organization_id])
    create index(:customers_organizations, [:customer_id])
    create index(:customers_organizations, [:organization_id])
  end
end
