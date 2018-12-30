defmodule Octo.Accounts.Customer do
  use Ecto.Schema
  import Ecto.Changeset

  alias Octo.Accounts.Credential


  schema "customers" do
    field :name, :string
    has_one :credential, Credential

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
