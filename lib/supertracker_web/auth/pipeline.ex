defmodule Supertracker.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :supertracker,
    error_handler: Supertracker.Auth.ErrorHandler,
    module: Supertracker.Auth.Guardian

  plug Guardian.Plug.VerifySession

  plug Guardian.Plug.LoadResource, allow_blank: true
end
