defmodule Pns.Services.UserService do
  @moduledoc """
  The User service.
  """

  alias Pns.Repos.User

  def get_user(id) do
    User.get_user!(id)
  end

  def get_user_by_email(email) do
    User.get_user_by_email(email)
  end

  def upsert(changeset) do
    User.upsert(changeset)
  end
end
