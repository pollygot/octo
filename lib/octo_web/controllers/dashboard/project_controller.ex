defmodule OctoWeb.Dashboard.ProjectController do
  use OctoWeb, :controller

  alias Octo.Products
  alias Octo.Products.Project
  alias Octo.Accounts

  def action(conn, _) do
    organization = Accounts.get_organization!(conn.params["organization_id"])
    args = [conn, conn.params, organization]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, organization) do
    projects = Products.list_projects(organization)
    render(conn, "index.html", projects: projects, organization: organization)
  end

  def new(conn, _params, organization) do
    changeset = Products.change_project(%Project{organization_id: organization.id})
    render(conn, "new.html", changeset: changeset, organization: organization)
  end

  def create(conn, %{"project" => project_params}, organization) do
    project_params = project_params |> Map.put("organization_id", organization.id)

    case Products.create_project(project_params) do
      {:ok, project} ->
        conn
        |> put_flash(:info, "Project created successfully.")
        |> redirect(to: Routes.dashboard_organization_project_path(conn, :show, organization, project))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, organization: organization)
    end
  end

  def show(conn, %{"id" => id}, organization) do
    project = Products.get_project!(organization, id)
    render(conn, "show.html", project: project, organization: organization)
  end

  def edit(conn, %{"id" => id}, organization) do
    project = Products.get_project!(organization, id)
    changeset = Products.change_project(project)
    render(conn, "edit.html", project: project, changeset: changeset, organization: organization)
  end

  def update(conn, %{"id" => id, "project" => project_params}, organization) do
    project = Products.get_project!(organization, id)

    case Products.update_project(project, project_params) do
      {:ok, project} ->
        conn
        |> put_flash(:info, "Project updated successfully.")
        |> redirect(to: Routes.dashboard_organization_project_path(conn, :show, organization, project))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", project: project, changeset: changeset, organization: organization)
    end
  end

  def delete(conn, %{"id" => id}, organization) do
    project = Products.get_project!(organization, id)
    {:ok, _project} = Products.delete_project(project)

    conn
    |> put_flash(:info, "Project deleted successfully.")
    |> redirect(to: Routes.dashboard_organization_project_path(conn, :index, organization))
  end
end
