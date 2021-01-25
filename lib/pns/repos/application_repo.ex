defmodule Pns.Repos.Application do
  @moduledoc """
  The Application reporsitory.
  """

  import Ecto.Query, warn: false
  alias Pns.Repo

  alias Pns.Schema.Application
  alias Pns.Schema.Event
  alias Pns.Schema.UserResponse

  @doc """
  Returns the list of applications.

  ## Examples

      iex> list_applications()
      [%Application{}, ...]

  """
  def list_applications do
    Repo.all(Application)
  end

  @doc """
  Gets a single application.

  Raises `Ecto.NoResultsError` if the Application does not exist.

  ## Examples

      iex> get_application!(123)
      %Application{}

      iex> get_application!(456)
      ** (Ecto.NoResultsError)

  """
  def get_application!(id), do: Repo.get!(Application, id)

  @doc """
  Gets a single application by key.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_application_by_key!(123)
      %Event{}

      iex> get_application_by_key!(456)
      ** (Ecto.NoResultsError)

  """
  def get_application_by_key!(key), do: Repo.get_by!(Application, key: key)

  @doc """
  Creates a application.

  ## Examples

      iex> create_application(%{field: value})
      {:ok, %Application{}}

      iex> create_application(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_application(attrs \\ %{}) do
    %Application{}
    |> Application.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a application.

  ## Examples

      iex> update_application(application, %{field: new_value})
      {:ok, %Application{}}

      iex> update_application(application, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_application(%Application{} = application, attrs) do
    application
    |> Application.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a application.

  ## Examples

      iex> delete_application(application)
      {:ok, %Application{}}

      iex> delete_application(application)
      {:error, %Ecto.Changeset{}}

  """
  def delete_application(%Application{} = application) do
    Repo.delete(application)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking application changes.

  ## Examples

      iex> change_application(application)
      %Ecto.Changeset{source: %Application{}}

  """
  def change_application(%Application{} = application) do
    Application.changeset(application, %{})
  end

  def get_recent_survey_data(application_id) do
    current_time = DateTime.utc_now()

    query =
      from e in Event,
        order_by: [desc: e.end_time],
        where: e.application_id == ^application_id and e.end_time < ^current_time,
        limit: 1

    from(
      ur in UserResponse,
      left_join: e in subquery(query),
      group_by: [e.name, ur.response],
      select: %{name: e.name, rating: ur.response, count: count(ur.response)},
      order_by: [asc: ur.response]
    )
    |> Repo.all()
  end
end
