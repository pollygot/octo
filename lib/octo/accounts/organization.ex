defmodule Octo.Accounts.Organization do
  use Ecto.Schema
  import Ecto.Changeset


  schema "organizations" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
