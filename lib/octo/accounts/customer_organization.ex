defmodule Octo.Accounts.CustomerOrganization do
  use Ecto.Schema
  import Ecto.Changeset
  alias Octo.Accounts.{Customer, Organization}

  schema "customers_organizations" do
    belongs_to :customer, Customer
    belongs_to :organization, Organization

    timestamps()
  end

  @doc false
  def changeset(customer_organization, attrs) do
    customer_organization
    |> cast(attrs, [])
    |> validate_required([])
  end
end
