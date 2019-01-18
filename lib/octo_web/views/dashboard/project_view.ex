defmodule OctoWeb.Dashboard.ProjectView do
  use OctoWeb, :view
  def count_projects(project_flags) do
    Enum.count(project_flags)
  end

  def count_users(project_users) do
    Enum.count(project_users)
  end

end
