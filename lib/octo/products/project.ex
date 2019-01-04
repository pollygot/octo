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
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
