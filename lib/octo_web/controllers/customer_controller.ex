defmodule OctoWeb.CustomerController do
  use OctoWeb, :controller

  alias Octo.Accounts
  alias Octo.Accounts.Customer

  def new(conn, _params) do
    changeset = Accounts.change_customer(%Customer{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"customer" => customer_params}) do
    case Accounts.register_customer(customer_params) do
      {:ok, customer} ->
        conn
        |> OctoWeb.Auth.login(customer)
        |> put_flash(:info, "#{customer.name} created!")
        |> redirect(to: Routes.dashboard_customer_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

end
