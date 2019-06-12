defmodule SupertrackerWeb.Router do
  use SupertrackerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # bunch of Guardian plugs. VerifySession plug checks for a token existence in a session,
  # LoadResource plug fetches a value from token’s sub field and serializes it with the serializer module we’ve created earlier
  # (it makes Guardian.Plug.current_resource(conn) function works).

  pipeline :with_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug SupertrackerWeb.CurrentUser
  end

  scope "/", SupertrackerWeb do
    pipe_through [:browser, :with_session]

    get "/", PageController, :index
    resources "/users", UserController, only: [:show, :new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", SupertrackerWeb do
  #   pipe_through :api
  # end
end
