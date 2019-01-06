defmodule OctoWeb.Dashboard.PageController do
  use OctoWeb, :controller
  alias Octo.Accounts

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_customer]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, current_customer) do
    organizations = Accounts.list_customer_organizations(current_customer)

    conn
    |> assign(:organizations, organizations)
    |> render("index.html", current_customer: current_customer)
  end

end
