defmodule OctoWeb.Dashboard.PageController do
  use OctoWeb, :controller
  alias Octo.Accounts
  alias Octo.Products

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_customer]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, current_customer) do
    organizations = Accounts.list_customer_organizations(current_customer)
    organization_projects_list = Enum.map(organizations, fn x -> Products.list_organization_projects(x) end)
    organization_projects = Enum.concat(organization_projects_list)

    conn
    |> assign(:organizations, organizations)
    |> assign(:organization_projects, organization_projects)
    |> render("index.html", current_customer: current_customer)
  end

end
