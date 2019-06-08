defmodule SupertrackerWeb.PageController do
  use SupertrackerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
