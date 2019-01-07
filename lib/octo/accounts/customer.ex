defmodule Octo.Accounts.Customer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Octo.Accounts.Credential
  alias Octo.Accounts.Organization

  schema "customers" do
    field :name, :string
    has_one :credential, Credential
    many_to_many :organizations, Organization, join_through: "customers_organizations", on_delete: :delete_all

    timestamps()
  end

  @doc false
  def registration_changeset(customer, attrs) do
    customer
    |> changeset(attrs)
    |> cast_assoc(:credential, with: &Credential.changeset/2, required: true)
  end

  def changeset(customer, attrs) do
    customer
      |> cast(attrs, [:name])
      |> validate_required([:name])
      |> validate_length(:name, min: 1, max: 20)
  end

end
