defmodule Octo.Accounts.Organization do
  use Ecto.Schema
  import Ecto.Changeset
  alias Octo.Accounts.Customer


  schema "organizations" do
    field :name, :string
    many_to_many :customers, Customer, join_through: Octo.Accounts.CustomerOrganization, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
