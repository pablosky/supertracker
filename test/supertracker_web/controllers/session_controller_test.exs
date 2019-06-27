defmodule SupertrackerWeb.SessionControllerTest do
  use SupertrackerWeb.ConnCase
  import Ecto.Query
  alias Supertracker.User
  require IEx

  test 'GET /sessions/new', %{conn: conn} do
    conn = get conn, "/sessions/new"
    assert html_response(conn, 200)
  end

  describe "#create" do
    test 'POST /sessions', %{conn: conn} do
      session_params = %{
        email: "user@example.com",
        password: "password",
      }
      {:ok, user} = create_user()
      post conn, "/sessions", [session: session_params]
      assert redirected_to(conn) == "/users/#{inspect user.id}"
    end
  end
  #
  # test 'GET /user/show', %{conn: conn} do
  #   post conn, "/users", [user: @params]
  #   user = get_last_user()
  #   conn = get conn, "/users/#{inspect user.id}"
  #   assert html_response(conn, 200)
  # end
  #
  defp create_user do
    user_params = %{
      email: "user@example.com",
      username: "username",
      password: "password",
    }
    changeset = %User{} |> User.registration_changeset(user_params)
    Supertracker.Repo.insert(changeset)
  end


  # defp get_last_user do
  #   Supertracker.Repo.one(from u in User, order_by: [desc: u.id], limit: 1)
  # end

end
