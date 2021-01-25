defmodule PnsWeb.ApplicationController do
  use PnsWeb, :controller

  alias Pns.Schema.Application
  alias Pns.Services.ApplicationService

  def index(conn, _params) do
    applications = ApplicationService.list_applications(Plug.Conn.get_session(conn, :user_id))

    render(conn, "index.html", applications: applications)
  end

  def new(conn, _params) do
    changeset = ApplicationService.change_application(%Application{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"application" => application_params}) do
    application_params =
      application_params
      |> Map.put("creator_id", Plug.Conn.get_session(conn, :user_id))
      |> Map.put("key", UUID.uuid4())

    case ApplicationService.create_application(application_params) do
      {:ok, _application} ->
        applications = ApplicationService.list_applications(Plug.Conn.get_session(conn, :user_id))

        conn
        |> put_flash(:info, "Application created successfully.")
        |> redirect(to: Routes.application_path(conn, :index, applications))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    application = ApplicationService.get_application(id)
    data = ApplicationService.get_recent_survey_data(id)
    render(conn, "show.html", %{application: application, data: data})
  end

  def edit(conn, %{"id" => id}) do
    application = ApplicationService.get_application(id)
    changeset = ApplicationService.change_application(application)
    render(conn, "edit.html", application: application, changeset: changeset)
  end

  def update(conn, %{"id" => id, "application" => application_params}) do
    application = ApplicationService.get_application(id)

    case ApplicationService.update_application(application, application_params) do
      {:ok, application} ->
        conn
        |> put_flash(:info, "Application updated successfully.")
        |> redirect(to: Routes.application_path(conn, :show, application))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", application: application, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    application = ApplicationService.get_application(id)
    {:ok, _event} = ApplicationService.delete_application(application)

    conn
    |> put_flash(:info, "Application deleted successfully.")
    |> redirect(to: Routes.application_path(conn, :index))
  end
end
