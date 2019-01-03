defmodule OctoWeb.Dashboard.PageController do
  use OctoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

end
