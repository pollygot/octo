defmodule Octo.Accounts do

  import Ecto.Query, warn: false
  alias Octo.Repo
  alias Octo.Accounts.Customer
  alias Octo.Accounts.Organization


  def link_customer_and_organization(%Customer{} = customer, %Organization{} = organization) do
    organization = Repo.preload(organization, :customers)
    customers = organization.customers ++ [customer]
                |> Enum.map(&Ecto.Changeset.change/1)

    organization
    |> Ecto.Changeset.change
    |> Ecto.Changeset.put_assoc(:customers, customers)
    |> Repo.update
  end

  def list_customer_organizations(%Customer{organizations: org}), do: org

  def create_organization(%Customer{} = customer, attrs \\ %{}) do
    customer_changeset = Ecto.Changeset.change(customer)

    %Organization{}
    |> Organization.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:customers, [customer_changeset])
    |> Repo.insert()
  end

  def register_customer(attrs \\ %{}) do
    %Customer{}
    |> Customer.registration_changeset(attrs)
    |> Repo.insert()
  end

  def get_customer_by_email(email) do
    from(c in Customer, join: a in assoc(c, :credential), where: a.email == ^email)
    |> Repo.one()
    |> Repo.preload(:credential)
  end

  def authenticate_by_email_and_pass(email, given_pass) do
    customer = get_customer_by_email(email)

    cond do
      customer && Comeonin.Pbkdf2.checkpw(given_pass, customer.credential.password_hash) ->
        {:ok, customer}
      customer ->
        {:error, :unauthorized}
      true ->
        Comeonin.Bcrypt.dummy_checkpw()
        {:error, :not_found}
    end
  end

  def list_customers do
    Repo.all(Customer)
  end

  def get_customer!(id), do: Repo.get!(Customer, id) |> Repo.preload(organizations: :customers)

  def create_customer(attrs \\ %{}) do
    %Customer{}
    |> Customer.changeset(attrs)
    |> Repo.insert()
  end

  def update_customer(%Customer{} = customer, attrs) do
    customer
    |> Customer.changeset(attrs)
    |> Repo.update()
  end

  def delete_customer(%Customer{} = customer) do
    Repo.delete(customer)
  end

  def change_customer(%Customer{} = customer) do
    Customer.changeset(customer, %{})
  end

  alias Octo.Accounts.Credential

  def list_credentials do
    Repo.all(Credential)
  end

  def get_credential!(id), do: Repo.get!(Credential, id)

  def create_credential(attrs \\ %{}) do
    %Credential{}
    |> Credential.changeset(attrs)
    |> Repo.insert()
  end

  def update_credential(%Credential{} = credential, attrs) do
    credential
    |> Credential.changeset(attrs)
    |> Repo.update()
  end

  def delete_credential(%Credential{} = credential) do
    Repo.delete(credential)
  end

  def change_credential(%Credential{} = credential) do
    Credential.changeset(credential, %{})
  end

  alias Octo.Accounts.Organization

  def list_organizations do
    Repo.all(Organization)
  end

  def get_organization!(id), do: Repo.get!(Organization, id)

  def update_organization(%Organization{} = organization, attrs) do
    organization
    |> Organization.changeset(attrs)
    |> Repo.update()
  end

  def delete_organization(%Organization{} = organization) do
    Repo.delete(organization)
  end

  def change_organization(%Organization{} = organization) do
    Organization.changeset(organization, %{})
  end
end
