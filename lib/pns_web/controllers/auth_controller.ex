defmodule PnsWeb.AuthController do
  use PnsWeb, :controller
  plug Ueberauth
  alias Pns.Repo
  alias Pns.Account.User

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
      case Repo.get_by(User, email: auth.info.email) do
        nil -> %User{email: auth.info.email}
        user -> user
      end
      |> IO.inspect(label: "user")
      |> User.changeset(user_params)
      |> IO.inspect(label: "user_params")
      |> Repo.insert_or_update()

    case result do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Thank you for signing in!")
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end
end
