defmodule Octo.Repo do
  use Ecto.Repo,
    otp_app: :octo,
    adapter: Ecto.Adapters.Postgres
end
