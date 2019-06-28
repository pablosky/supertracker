defmodule Supertracker.Auth.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Supertracker.Repo

  alias Supertracker.User

  def get_user(id), do: Repo.get(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
      |> User.registration_changeset(attrs)
      |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  def change_user(%User{} = user) do
    User.update_changeset(user, %{})
  end

  def authenticate_by_email_password(email, password) do
    User
    |> Repo.get_by(email: email)
    |> check_password(password)
  end

  defp check_password(nil, _password), do: {:error, :unauthorized}

  defp check_password(%User{} = user, password) do
    case Comeonin.Bcrypt.check_pass(user, password) do
      {:ok, _user} = result -> result
      {:error, _message} ->  {:error, :unauthorized}
    end
  end
end
