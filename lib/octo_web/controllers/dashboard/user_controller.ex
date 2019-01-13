defmodule OctoWeb.Dashboard.UserController do
  use OctoWeb, :controller

  alias Octo.Products
  alias Octo.Products.User
  alias Octo.Accounts

  def action(conn, _) do
    organization = Accounts.get_organization!(conn.params["organization_id"])
    project = Products.get_project!(organization, conn.params["project_id"])
    args = [conn, conn.params, organization, project]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, organization, project) do
    users = Products.list_users(project)
    render(conn, "index.html", users: users, project: project, organization: organization)
  end

  def new(conn, _params, organization, project) do
    changeset = Products.change_user(%User{project_id: project.id})
    render(conn, "new.html", changeset: changeset, project: project, organization: organization)
  end

  def create(conn, %{"user" => user_params}, organization, project) do
    user_params = user_params |> Map.put("project_id", project.id)

    case Products.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Routes.dashboard_organization_project_user_path(conn, :index, organization, project))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, project: project, organization: organization)
    end
  end

  def show(conn, %{"id" => id}, organization, project) do
    user = Products.get_user!(project, id)
    render(conn, "show.html", user: user, project: project, organization: organization)
  end

  def edit(conn, %{"id" => id}, organization, project) do
    user = Products.get_user!(project, id)
    changeset = Products.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset, project: project, organization: organization)
  end

  def update(conn, %{"id" => id, "user" => user_params}, organization, project) do
    user = Products.get_user!(project, id)

    case Products.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.dashboard_organization_project_user_path(conn, :index, organization, project))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset, project: project, organization: organization)
    end
  end

  def delete(conn, %{"id" => id}, organization, project) do
    user = Products.get_user!(project, id)
    {:ok, _user} = Products.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.dashboard_organization_project_user_path(conn, :index, project, organization))
  end
end
