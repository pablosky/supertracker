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
       |> redirect(to: user_path(conn, :show, user))
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

end
