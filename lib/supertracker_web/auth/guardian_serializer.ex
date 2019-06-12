# web/auth/guardian_serializer.ex sets guardian as a dependency
# We had switched to adding Guardian just before SupertracKER'S.SessionController’s
defmodule SupertrackerWeb.GuardianSerializer do
  @behaviour Guardian.Serializer
  alias Supertracker.Repo
  alias Supertracker.User
  def for_token(user = %User{}), do: { :ok, "User:#{user.id}" }
  def for_token(_), do: { :error, "Unknown resource type" }
  def from_token("User:" <> id), do: { :ok, Repo.get(User, id) }
  def from_token(_), do: { :error, "Unknown resource type" }
end
