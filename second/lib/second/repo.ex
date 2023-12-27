defmodule Second.Repo do
  use Ecto.Repo,
    otp_app: :second,
    adapter: Ecto.Adapters.Postgres
end
