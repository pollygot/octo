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


  alias Octo.Products.Flag

  @doc """
  Returns the list of flags.

  ## Examples

      iex> list_flags()
      [%Flag{}, ...]

  """
  def list_flags(project) do
    Flag
    |> where([f], f.project_id == ^project.id)
    |> Repo.all()
  end

  @doc """
  Gets a single flag.

  Raises `Ecto.NoResultsError` if the Flag does not exist.

  ## Examples

      iex> get_flag!(123)
      %Flag{}

      iex> get_flag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_flag!(project, id) do
    Flag
    |> where([f], f.project_id == ^project.id)
    |> Repo.get!(id)
  end

  @doc """
  Creates a flag.

  ## Examples

      iex> create_flag(%{field: value})
      {:ok, %Flag{}}

      iex> create_flag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_flag(attrs \\ %{}) do
    %Flag{}
    |> Flag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a flag.

  ## Examples

      iex> update_flag(flag, %{field: new_value})
      {:ok, %Flag{}}

      iex> update_flag(flag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_flag(%Flag{} = flag, attrs) do
    flag
    |> Flag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Flag.

  ## Examples

      iex> delete_flag(flag)
      {:ok, %Flag{}}

      iex> delete_flag(flag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_flag(%Flag{} = flag) do
    Repo.delete(flag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking flag changes.

  ## Examples

      iex> change_flag(flag)
      %Ecto.Changeset{source: %Flag{}}

  """
  def change_flag(%Flag{} = flag) do
    Flag.changeset(flag, %{})
  end
end
