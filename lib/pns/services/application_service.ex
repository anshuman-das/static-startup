defmodule Pns.Services.ApplicationService do
  @moduledoc """
  The Application service.
  """

  alias Pns.Repos.Application

  def list_applications do
    Application.list_applications()
  end

  def get_application(id) do
    Application.get_application!(id)
  end

  def create_application(attr) do
    Application.create_application(attr)
  end

  def update_application(application, attr) do
    Application.update_application(application, attr)
  end

  def delete_application(application) do
    Application.delete_application(application)
  end

  def change_application(application) do
    Application.change_application(application)
  end
end