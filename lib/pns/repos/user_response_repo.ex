defmodule Pns.Repos.UserResponse do
  @moduledoc """
  The UserResponse reporsitory.
  """

  import Ecto.Query, warn: false
  alias Pns.Repo

  alias Pns.Schema.UserResponse

  def list_user_responses do
    Repo.all(UserResponse)
  end

  def get_user_response!(id), do: Repo.get!(UserResponse, id)

  def get_user_responses_by_user!(user), do: Repo.get_by!(UserResponse, user: user)

  def create_user_response(attrs \\ %{}) do
    %UserResponse{}
    |> UserResponse.changeset(attrs)
    |> Repo.insert()
  end

  def update_user_response(%UserResponse{} = user_response, attrs) do
    user_response
    |> UserResponse.changeset(attrs)
    |> Repo.update()
  end

  def delete_user_response(%UserResponse{} = user_response) do
    Repo.delete(user_response)
  end

  def change_user_response(%UserResponse{} = user_response) do
    UserResponse.changeset(user_response, %{})
  end
end
