defmodule OctoWeb.ProjectChannel do
  use OctoWeb, :channel
  alias Octo.Products


  def join("project:" <> project_id, _params, socket) do
    project = Products.get_project_from_id(project_id)
    socket = assign(socket, :project, project)
    response = %{channel: "project:#{project_id}"}
    {:ok, response, socket}
  end

  def handle_in("message:add", %{"message" => content}, socket) do
    flags = Products.list_flags(socket.assigns.project)
    project_id = socket.assigns.project.id
    broadcast!(socket, "project:#{project_id}:new_message", %{content: content <> inspect(flags)})
    {:reply, :ok, socket}
  end

end
