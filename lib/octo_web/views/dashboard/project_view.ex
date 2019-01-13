defmodule OctoWeb.Dashboard.ProjectView do
  use OctoWeb, :view
  def count_projects(project_flags) do
    Enum.count(project_flags)
  end

end
