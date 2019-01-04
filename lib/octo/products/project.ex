defmodule Octo.Products.Project do
  use Ecto.Schema
  import Ecto.Changeset


  schema "projects" do
    field :name, :string
    belongs_to :organization, Octo.Accounts.Organization

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:name, :organization_id])
    |> validate_required([:name, :organization_id])
  end
end
