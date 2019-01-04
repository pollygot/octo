defmodule OctoWeb.Dashboard.PageController do
  use OctoWeb, :controller
  alias Octo.Products
  alias Octo.Accounts

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_customer]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, current_customer) do
    organizations = Accounts.grab_organization(current_customer)
    projects = "hey"
    conn
    |> assign(:organizations, organizations)
    |> assign(:projects, projects)
    |> render("index.html", current_customer: current_customer)
  end

end
