defmodule Octo.Products do
  @moduledoc """
  The Products context.
  """

  import Ecto.Query, warn: false
  alias Octo.Repo
  alias Octo.Products.Project
  alias Octo.Accounts.Organization

  def list_only_organization_projects(list_of_projects) do
    Enum.map(list_of_projects, fn (x) -> x.name end)
  end

  def list_organization_projects(%Organization{} = organization) do
    Project
    |> organization_projects_query(organization)
    |> Repo.all()
    |> Repo.preload(:organization)
  end

  def get_organization_project!(%Organization{} = organization, id) do
    from(p in Project, where: p.id == ^id)
    |> organization_projects_query(organization)
    |> Repo.one!()
  end

  defp organization_projects_query(query, %Organization{id: organization_id}) do
    from(p in query, where: p.organization_id == ^organization_id)
  end


  def list_projects(organization) do
    Project
    |> where([p], p.organization_id == ^organization.id)
    |> Repo.all()
  end

  def get_project!(organization, id) do
    Project
    |> where([p], p.organization_id == ^organization.id)
    |> Repo.get!(id)
  end

  def create_project(attrs \\ %{}) do
    %Project{}
    |> Project.changeset(attrs)
    |> Repo.insert()
  end

  def update_project(%Project{} = project, attrs) do
    project
    |> Project.changeset(attrs)
    |> Repo.update()
  end

  def delete_project(%Project{} = project) do
    Repo.delete(project)
  end

  def change_project(%Project{} = project) do
    Project.changeset(project, %{})
  end

end
