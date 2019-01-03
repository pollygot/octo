defmodule Octo.Repo.Migrations.CreateCustomersOrganizations do
  use Ecto.Migration

  def change do
    create table(:customers_organizations) do
      add :customer_id, references(:customers, on_delete: :nothing)
      add :organization_id, references(:organizations, on_delete: :nothing)

      timestamps()
    end

    create index(:customers_organizations, [:customer_id])
    create index(:customers_organizations, [:organization_id])
    create unique_index(:customers_organizations, [:customer_id, :organization_id])
  end
end
