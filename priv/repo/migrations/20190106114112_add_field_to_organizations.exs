defmodule Octo.Repo.Migrations.AddFieldToOrganizations do
  use Ecto.Migration

  def change do
    alter table(:organizations) do
      add :admin_id, references(:customers, on_delete: :nothing)
    end
  end
end
