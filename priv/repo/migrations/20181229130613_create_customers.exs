defmodule Octo.Repo.Migrations.CreateCustomers do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add :name, :string, null: false

      timestamps()
    end

  end
end
