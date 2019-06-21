defmodule SupertrackerWeb.UserControllerTest do
  use SupertrackerWeb.ConnCase

  test 'GET /users/new', %{conn: conn} do
    conn = get conn, "/users/new"
    assert html_response(conn, 200)
  end

  describe "#create" do
    @params %{
      email: "user@example.com",
      username: "username",
      password: "password",
    }

    test 'POST /users', %{conn: conn} do
      conn = post conn, "/users", [user: @params]
      user = get_last_user()
      assert redirected_to(conn) == "/users/#{inspect user.id}"
      assert user.email == "user@example.com"
    end
  end

  defp get_last_user do
    alias Supertracker.User
    import Ecto.Query

    Supertracker.Repo.one(from u in User, order_by: [desc: u.id], limit: 1)
  end

end
