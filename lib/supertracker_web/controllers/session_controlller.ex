defmodule SupertrackerWeb.SessionController do
  use SupertrackerWeb, :controller
  # plug cleans blank to nil params
  plug :scrub_params, "session" when action in ~w(create)a

 alias Supertracker.Auth.Accounts
 alias Supertracker.Auth.Guardian

 def new(conn, _params) do
   render conn, "new.html"
 end

def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
   case Accounts.authenticate_by_email_password(email, password) do
     {:ok, user} ->
       conn
       |> Supertracker.Auth.Guardian.Plug.sign_in(user)
       |> put_flash(:info, "You’re now logged in!")
       |> redirect(to: page_path(conn, :index))
     {:error, :unauthorized} ->
       conn
       |> put_flash(:error, "Bad email/password combination")
       |> render("new.html")
   end
 end

 def delete(conn, _params) do
   conn
   |> Guardian.Plug.sign_out()
   |> put_flash(:info, "See you later!")
   |> redirect(to: page_path(conn, :index))
 end
  # def new(conn, _) do
  #   render conn, "new.html"
  # end
  #
  # def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
  #   # try to get user by unique email from DB
  #   user = Supertracker.Repo.get_by(User, email: email)
  #   # examine the result
  #   result = cond do
  #     # if user was found and provided password hash equals to stored
  #     # hash
  #     user && checkpw(password, user.password_hash) ->
  #       {:ok, login(conn, user)}
  #     # else if we just found the user
  #     user ->
  #       {:error, :unauthorized, conn}
  #     # otherwise
  #     true ->
  #       dummy_checkpw()
  #       # simulate check password hash timing
  #       {:error, :not_found, conn}
  #   end
  #   case result do
  #     {:ok, conn} ->
  #       conn
  #       |> put_flash(:info, "You’re now logged in!")
  #       |> redirect(to: page_path(conn, :index))
  #     {:error, _reason, conn} ->
  #       conn
  #       |> put_flash(:error, "Invalid email/password combination")
  #       |> render("new.html")
  #   end
  # end
  #
  # defp login(conn, user) do
  #   conn
  #   |> Supertracker.Auth.Guardian.Plug.sign_in(user)
  #   |> put_flash(:info, "You’re now logged in!")
  #   |> redirect(to: page_path(conn, :index))
  # end
  #
  # def delete(conn, _) do
  #   conn
  #   |> logout
  #   |> put_flash(:info, "See you later!")
  #   |> redirect(to: page_path(conn, :index))
  # end
  #
  # defp logout(conn) do
  #   Supertracker.Auth.Guardian.Plug.sign_out(conn)
  # end
end
