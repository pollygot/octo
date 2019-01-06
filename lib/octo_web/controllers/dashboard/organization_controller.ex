defmodule OctoWeb.Dashboard.OrganizationController do
  use OctoWeb, :controller

  alias Octo.Accounts
  alias Octo.Accounts.Organization

  def index(conn, _params) do
    organizations = Accounts.list_organizations()
    render(conn, "index.html", organizations: organizations)
  end

  def new(conn, _params) do
    changeset = Accounts.change_organization(%Organization{})
    render(conn, "new.html", changeset: changeset)
  end

  @spec create(
          atom() | %{__struct__: Phoenix.Socket | Plug.Conn | URI, assigns: atom() | map()},
          map()
        ) :: Plug.Conn.t()
  def create(conn, %{"organization" => organization_params}) do
    case Accounts.create_organization(organization_params) do
      {:ok, organization} ->
        conn
        |> put_flash(:info, "Organization created successfully.")
        |> redirect(to: Routes.dashboard_organization_path(conn, :show, organization))

        Accounts.add_customer_organization(conn.assigns.current_customer, organization)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    organization = Accounts.get_organization!(id)
    render(conn, "show.html", organization: organization)
  end

  def edit(conn, %{"id" => id}) do
    organization = Accounts.get_organization!(id)
    changeset = Accounts.change_organization(organization)
    render(conn, "edit.html", organization: organization, changeset: changeset)
  end

  def update(conn, %{"id" => id, "organization" => organization_params}) do
    organization = Accounts.get_organization!(id)

    case Accounts.update_organization(organization, organization_params) do
      {:ok, organization} ->
        conn
        |> put_flash(:info, "Organization updated successfully.")
        |> redirect(to: Routes.dashboard_organization_path(conn, :show, organization))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", organization: organization, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    organization = Accounts.get_organization!(id)
    {:ok, _organization} = Accounts.delete_organization(organization)

    conn
    |> put_flash(:info, "Organization deleted successfully.")
    |> redirect(to: Routes.dashboard_organization_path(conn, :index))
  end
end
