defmodule PnsWeb.PageController do
  use PnsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
