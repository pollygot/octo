defmodule Octo.Products do
  @moduledoc """
  The Products context.
  """

  import Ecto.Query, warn: false
  alias Octo.Repo
  alias Octo.Accounts.Organization
  alias Octo.Products.{Flag, User, UserFlag, Project}


  def left_flags(overrides, project_flags) do
    override_id = Enum.map(overrides, fn x -> x.flag_id end)
    Enum.filter(project_flags, fn x -> !Enum.member?(override_id, x.id) end)
  end

  def update_or_insert_userflag(user, flag) do
    Repo.insert!(%UserFlag{user_id: user.id, flag_id: flag.id, is_on: false},
                on_conflict: [set: [is_on: !flag.is_on]], conflict_target: [:user_id, :flag_id])
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

  def list_project_flags(%Project{} = project) do
    Flag
    |> project_flags_query(project)
    |> Repo.all()
    |> Repo.preload(:project)
  end

  def get_project_flag!(%Project{} = project, id) do
    from(f in Flag, where: f.id == ^id)
    |> project_flags_query(project)
    |> Repo.one!()
  end

  defp project_flags_query(query, %Project{id: project_id}) do
    from(f in query, where: f.project_id == ^project_id)
  end

  def list_project_users(%Project{} = project) do
    User
    |> project_users_query(project)
    |> Repo.all()
    |> Repo.preload(:project)
  end

  def get_project_user!(%Project{} = project, id) do
    from(u in User, where: u.id == ^id)
    |> project_users_query(project)
    |> Repo.one!()
  end

  defp project_users_query(query, %Project{id: project_id}) do
    from(u in query, where: u.project_id == ^project_id)
  end

  def list_user_flags(user) do
    UserFlag
    |> where([u], u.user_id == ^user.id)
    |> Repo.all()
    |> Repo.preload(:flag)
  end

  def list_projects(organization) do
    Project
    |> where([p], p.organization_id == ^organization.id)
    |> Repo.all()
  end

  def get_project_from_id(id) do
    Project
    |> Repo.get!(id)
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

  def list_flags(project) do
    Flag
    |> where([f], f.project_id == ^project.id)
    |> Repo.all()
  end

  def get_flag!(project, id) do
    Flag
    |> where([f], f.project_id == ^project.id)
    |> Repo.get!(id)
  end

  def create_flag(attrs \\ %{}) do
    %Flag{}
    |> Flag.changeset(attrs)
    |> Repo.insert()
  end

  def update_flag(%Flag{} = flag, attrs) do
    flag
    |> Flag.changeset(attrs)
    |> Repo.update()
  end

  def delete_flag(%Flag{} = flag) do
    Repo.delete(flag)
  end

  def change_flag(%Flag{} = flag) do
    Flag.changeset(flag, %{})
  end

  alias Octo.Products.User

  def list_users(project) do
    User
    |> where([u], u.project_id == ^project.id)
    |> Repo.all()
  end

  def get_user!(project, id) do
    User
    |> where([u], u.project_id == ^project.id)
    |> Repo.get!(id)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
