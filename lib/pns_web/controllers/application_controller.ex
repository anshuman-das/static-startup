defmodule PnsWeb.ApplicationController do
  use PnsWeb, :controller

  alias Pns.Schema.Application
  alias Pns.Services.ApplicationService

  def index(conn, _params) do
    case Plug.Conn.get_session(conn, :user_id) do
      nil ->
        conn
        |> put_flash(:error, "Please Login")
        |> redirect(to: Routes.page_path(conn, :index))

      _ ->
        applications =
          ApplicationService.list_applications()
          |> Enum.filter(fn x -> x.creator_id == Plug.Conn.get_session(conn, :user_id) end)

        IO.inspect(applications, label: ">>>>>>>>>")
        render(conn, "index.html", applications: applications)
    end
  end

  def new(conn, _params) do
    case Plug.Conn.get_session(conn, :user_id) do
      nil ->
        conn
        |> put_flash(:error, "Please Login")
        |> redirect(to: Routes.page_path(conn, :index))

      _ ->
        changeset = ApplicationService.change_application(%Application{})
        render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"application" => application_params}) do
    application_params =
      application_params
      |> Map.put("creator_id", Plug.Conn.get_session(conn, :user_id))
      |> Map.put("key", UUID.uuid4())
      |> IO.inspect(label: ">>>>>>>>>>>>")

    case ApplicationService.create_application(application_params) do
      {:ok, application} ->
        conn
        |> put_flash(:info, "Application created successfully.")
        |> redirect(to: Routes.application_path(conn, :show, application))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    case Plug.Conn.get_session(conn, :user_id) do
      nil ->
        conn
        |> put_flash(:error, "Please Login")
        |> redirect(to: Routes.page_path(conn, :index))

      _ ->
        application = ApplicationService.get_application(id)
        render(conn, "show.html", application: application)
    end
  end

  def edit(conn, %{"id" => id}) do
    case Plug.Conn.get_session(conn, :user_id) do
      nil ->
        conn
        |> put_flash(:error, "Please Login")
        |> redirect(to: Routes.page_path(conn, :index))

      _ ->
        application = ApplicationService.get_application(id)
        changeset = ApplicationService.change_application(application)
        render(conn, "edit.html", application: application, changeset: changeset)
    end
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
