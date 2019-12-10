defmodule TwitterPheonix.Repo do
  use Ecto.Repo,
    otp_app: :twitterPheonix,
    adapter: Ecto.Adapters.Postgres
end
