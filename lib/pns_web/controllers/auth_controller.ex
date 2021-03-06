defmodule PnsWeb.AuthController do
  use PnsWeb, :controller
  plug Ueberauth
  alias Pns.Services.UserService
  alias Pns.Schema.User

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{
      first_name: auth.info.first_name,
      last_name: auth.info.last_name,
      picture: auth.info.image,
      provider: "google",
      updated_at: DateTime.utc_now()
    }

    result =
      case UserService.get_user_by_email(email: auth.info.email) do
        nil -> %User{email: auth.info.email}
        user -> user
      end
      |> User.changeset(user_params)
      |> UserService.upsert()

    case result do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Thank you for signing in!")
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.application_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> delete_session(:user_id)
    |> redirect(to: "/")
  end
end
