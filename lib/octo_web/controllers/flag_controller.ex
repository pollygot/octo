defmodule OctoWeb.FlagController do
  use OctoWeb, :controller

  alias Octo.Products
  alias Octo.Products.Flag

  def index(conn, _params) do
    flags = Products.list_flags()
    render(conn, "index.html", flags: flags)
  end

  def new(conn, _params) do
    changeset = Products.change_flag(%Flag{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"flag" => flag_params}) do
    case Products.create_flag(flag_params) do
      {:ok, flag} ->
        conn
        |> put_flash(:info, "Flag created successfully.")
        |> redirect(to: Routes.flag_path(conn, :show, flag))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    flag = Products.get_flag!(id)
    render(conn, "show.html", flag: flag)
  end

  def edit(conn, %{"id" => id}) do
    flag = Products.get_flag!(id)
    changeset = Products.change_flag(flag)
    render(conn, "edit.html", flag: flag, changeset: changeset)
  end

  def update(conn, %{"id" => id, "flag" => flag_params}) do
    flag = Products.get_flag!(id)

    case Products.update_flag(flag, flag_params) do
      {:ok, flag} ->
        conn
        |> put_flash(:info, "Flag updated successfully.")
        |> redirect(to: Routes.flag_path(conn, :show, flag))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", flag: flag, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    flag = Products.get_flag!(id)
    {:ok, _flag} = Products.delete_flag(flag)

    conn
    |> put_flash(:info, "Flag deleted successfully.")
    |> redirect(to: Routes.flag_path(conn, :index))
  end
end
