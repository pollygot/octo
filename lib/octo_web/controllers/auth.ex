defmodule OctoWeb.Auth do
  import Plug.Conn
  import Phoenix.Controller
  alias OctoWeb.Router.Helpers, as: Routes
  alias Octo.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    customer_id = get_session(conn, :customer_id)
    customer = customer_id && Accounts.get_customer!(customer_id)
    assign(conn, :current_customer, customer)
  end

  def login(conn, customer) do
    conn
    |> assign(:current_customer, customer)
    |> put_session(:customer_id, customer.id)
    |> configure_session(renew: true)
    |> redirect(to: Routes.dashboard_organization_path(conn, :index))
  end

  def login_by_email_and_pass(conn, email, given_pass) do
    case Accounts.authenticate_by_email_and_pass(email, given_pass) do
      {:ok, customer} -> {:ok, login(conn, customer)}
      {:error, :unauthorized} -> {:error, :unauthorized, conn}
      {:error, :not_found} -> {:error, :not_found, conn}
    end
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  def authenticate_customer(conn, _opts) do
    if conn.assigns.current_customer do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end

end
