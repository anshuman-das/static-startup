defmodule Pns.Services.Api.UserResponse do
  @moduledoc """
  The UserResponse service.
  """

  alias Pns.Repos.UserResponse

  def list_user_responses(event_id) do
    UserResponse.list_user_responses()
    |> Enum.filter(fn x -> x.event_id == event_id end)
  end

  def get_user_response(id) do
    UserResponse.get_user_response!(id)
  end

  def get_user_responses_by_user(user) do
    UserResponse.get_user_responses_by_user!(user)
  end

  def create_user_response(attr) do
    UserResponse.create_user_response(attr)
  end

  def update_user_response(user_response, attr) do
    UserResponse.update_user_response(user_response, attr)
  end

  def delete_user_response(user_response) do
    UserResponse.delete_user_response(user_response)
  end

  def change_user_response(user_response) do
    UserResponse.change_user_response(user_response)
  end
end
