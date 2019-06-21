defmodule SupertrackerWeb.UserControllerTest do
  use SupertrackerWeb.ConnCase

  test 'GET /users/new', %{conn: conn} do
    conn = get conn, "/users/new"
    assert html_response(conn, 200)
  end

  @params %{
    email: "user@example.com",
    username: "username",
    password: "password",
  }

  describe "#create" do

    test 'POST /users', %{conn: conn} do
      conn = post conn, "/users", [user: @params]
      user = get_last_user()
      assert redirected_to(conn) == "/users/#{inspect user.id}"
      assert user.email == "user@example.com"
    end
  end

  test 'GET /user/show', %{conn: conn} do
    post conn, "/users", [user: @params]
    user = get_last_user()
    conn = get conn, "/users/#{inspect user.id}"
    assert html_response(conn, 200)
  end

  defp get_last_user do
    alias Supertracker.User
    import Ecto.Query

    Supertracker.Repo.one(from u in User, order_by: [desc: u.id], limit: 1)
  end

end
