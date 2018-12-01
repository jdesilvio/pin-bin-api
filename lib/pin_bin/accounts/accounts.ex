defmodule PinBin.Accounts do
  @moduledoc"""
  Functions associated with user accounts.
  """

  import Ecto.Query, warn: false
  alias PinBin.Repo

  alias PinBin.User

  @doc """
  Returns a list of all users.

  ## Examples
      iex> list_users()
      [%User{}, ...]
  """
  def list_users, do: Repo.all(User)

  @doc """
  Gets a single user.

  ## Examples
      iex> get_user(123)
      %User{}

      iex> get_user(456)
      nil
  """
  def get_user(id), do: Repo.get(User, id)

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

  @doc """
  Gets a single user by their username.

  ## Examples
      iex> get_user_by_username('moe')
      %User{}

      iex> get_user_by_username('not a name')
      nil
  """
  def get_user_by_username(username) do
    case username do
      nil -> nil
      _ -> Repo.get_by(User, username: username)
    end
  end

  @doc """
  Gets a single user by their username.
  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples
      iex> get_user_by_username!('moe')
      %User{}

      iex> get_user_by_username!('not a name')
      ** (Ecto.NoResultsError)
  """
  def get_user_by_username!(username) do
    case username do
      nil -> nil
      _ -> Repo.get_by!(User, username: username)
    end
  end

  @doc """
  Gets a single user by their email.

  ## Examples
      iex> get_user_by_email('moe@stooges.com')
      %User{}

      iex> get_user_by_email('does@not.exist')
      nil
  """
  def get_user_by_email(email) do
    case email do
      nil -> nil
      _ -> Repo.get_by(User, email: String.downcase(email))
    end
  end

  @doc """
  Gets a single user by their email.
  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples
      iex> get_user_by_email!('moe')
      %User{}

      iex> get_user_by_email!('not a name')
      ** (Ecto.NoResultsError)
  """
  def get_user_by_email!(email) do
    case email do
      nil -> nil
      _ -> Repo.get_by!(User, email: String.downcase(email))
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples
      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}
  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  Creates a user.

  ## Examples
      iex> create_user(%{field: value})
    {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples
      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples
      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}
  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end
end
