defmodule OctoWeb.Dashboard.CustomerController do
  use OctoWeb, :controller

  alias Octo.Accounts
  # alias Octo.Accounts.Customer
  plug :authenticate_customer when action in [:index, :show]


  def index(conn, _params) do
    customers = Accounts.list_customers()
    render(conn, "index.html", customers: customers)
  end

  def show(conn, %{"id" => id}) do
    customer = Accounts.get_customer!(id)
    render(conn, "show.html", customer: customer)
  end

  def edit(conn, %{"id" => id}) do
    customer = Accounts.get_customer!(id)
    changeset = Accounts.change_customer(customer)
    render(conn, "edit.html", customer: customer, changeset: changeset)
  end

  def update(conn, %{"id" => id, "customer" => customer_params}) do
    customer = Accounts.get_customer!(id)

    case Accounts.update_customer(customer, customer_params) do
      {:ok, customer} ->
        conn
        |> put_flash(:info, "Customer updated successfully.")
        |> redirect(to: Routes.dashboard_customer_path(conn, :show, customer))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", customer: customer, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    customer = Accounts.get_customer!(id)
    {:ok, _customer} = Accounts.delete_customer(customer)

    conn
    |> put_flash(:info, "Customer deleted successfully.")
    |> redirect(to: Routes.dashboard_customer_path(conn, :index))
  end
end
