defmodule SchoolWars.Repo do
  use Ecto.Repo,
    otp_app: :school_wars,
    adapter: Ecto.Adapters.Postgres
end
