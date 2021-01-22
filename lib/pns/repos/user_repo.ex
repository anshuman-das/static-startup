defmodule Pns.Repos.User do
  @moduledoc """
  The User repository.
  """

  import Ecto.Query, warn: false
  alias Pns.Repo

  alias Pns.Schema.User

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by_email(email), do: Repo.get_by(User, email)

  def upsert(user), do: Repo.insert_or_update(user)
end
