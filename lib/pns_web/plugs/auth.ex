defmodule PnsWeb.Plugs.Auth do
  import Plug.Conn
  import Phoenix.Controller
  alias PnsWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    if _user_id = Plug.Conn.get_session(conn, :user_id) do
    else
      conn
      |> put_flash(:error, "Please Login")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end

    conn
  end
end
