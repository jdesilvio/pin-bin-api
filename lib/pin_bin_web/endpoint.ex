defmodule PinBinWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :pin_bin

  socket "/socket", PinBinWeb.UserSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  #plug Plug.Static,
  #  at: "/", from: :pin_bin, gzip: false,
  #  only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  #if code_reloading? do
  #  socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
  #  plug Phoenix.LiveReloader
  #  plug Phoenix.CodeReloader
  #end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  #plug Plug.Session,
  #  store: :cookie,
  #  key: "_pin_bin_key",
  #  signing_salt: "J8rvlxWx"

  plug PinBinWeb.Router

  # CORS plug
  # Will accept CORS requests from a Vue.js frontend
  # that uses Axios for HTTP requests.
  # Vue.js development servers go up on port 8080 by default.
  plug(
    Corsica,
    origins: "http://localhost:8080",
    log: [rejected: :error, invalid: :warn, accepted: :debug],
    allow_headers: ["content-type"],
    allow_credentials: true
  )
end
