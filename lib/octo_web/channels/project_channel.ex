defmodule OctoWeb.ProjectChannel do
  use OctoWeb, :channel
  alias Octo.Products


  def join("project:" <> project_id, _params, socket) do
    # project = Products.get_project!(project_id)
    # socket    = assign(socket, :project, project)
    response  = %{channel: "project:#{project_id}"}
    {:ok, response, socket}
  end

  def handle_in("message:add", %{"message" => content}, socket) do

    # flags = Products.list_flags(project)



    project_id = socket.assigns[:project_id]
    broadcast!(socket, "project:#{project_id}:new_message", %{content: content})
    {:reply, :ok, socket}
  end

end
