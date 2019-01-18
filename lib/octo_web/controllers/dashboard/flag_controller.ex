defmodule OctoWeb.Dashboard.FlagController do
  use OctoWeb, :controller

  alias Octo.Products
  alias Octo.Products.{Flag, UserFlag}
  alias Octo.Accounts

  def action(conn, _) do
    organization = Accounts.get_organization!(conn.params["organization_id"])
    project = Products.get_project!(organization, conn.params["project_id"])
    args = [conn, conn.params, organization, project]
    apply(__MODULE__, action_name(conn), args)
  end

  def check_user_flag(conn, user, organization, project) do
    user = Products.get_user!(project, conn.params["user_id"])
    flag = Products.get_flag!(project, conn.params["flag_id"])

    Products.update_or_insert_userflag(user, flag)

    conn
    |> put_flash(:info, "Flag overriden!")
    |> redirect(to: Routes.dashboard_organization_project_user_path(conn, :index, organization, project))
  end

  def index(conn, _params, organization, project) do
    flags = Products.list_flags(project)
    render(conn, "index.html", flags: flags, project: project, organization: organization)
  end

  def new(conn, _params, organization, project) do
    changeset = Products.change_flag(%Flag{project_id: project.id})
    render(conn, "new.html", changeset: changeset, project: project, organization: organization)
  end

  def create(conn, %{"flag" => flag_params}, organization, project) do
    flag_params = flag_params |> Map.put("project_id", project.id)

    case Products.create_flag(flag_params) do
      {:ok, flag} ->
        conn
        |> put_flash(:info, "Flag created successfully.")
        |> redirect(to: Routes.dashboard_organization_project_flag_path(conn, :index, organization, project))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, project: project, organization: organization)
    end
  end

  def show(conn, %{"id" => id}, organization, project) do
    flag = Products.get_flag!(project, id)
    render(conn, "show.html", flag: flag, project: project, organization: organization)
  end

  def edit(conn, %{"id" => id}, organization, project) do
    flag = Products.get_flag!(project, id)
    changeset = Products.change_flag(flag)
    render(conn, "edit.html", flag: flag, changeset: changeset, project: project, organization: organization)
  end

  def update(conn, %{"id" => id, "flag" => flag_params}, organization, project) do
    flag = Products.get_flag!(project, id)

    case Products.update_flag(flag, flag_params) do
      {:ok, flag} ->
        conn
        |> put_flash(:info, "Flag updated successfully.")
        |> redirect(to: Routes.dashboard_organization_project_flag_path(conn, :show, organization, project, flag))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", flag: flag, changeset: changeset, project: project, organization: organization)
    end
  end

  def delete(conn, %{"id" => id}, organization, project) do
    flag = Products.get_flag!(project, id)
    {:ok, _flag} = Products.delete_flag(flag)

    conn
    |> put_flash(:info, "Flag deleted successfully.")
    |> redirect(to: Routes.dashboard_organization_project_flag_path(conn, :index, project, organization))
  end
end
