defmodule Webcandy2.Repo do
  use Ecto.Repo,
    otp_app: :webcandy2,
    adapter: Ecto.Adapters.Postgres
end
