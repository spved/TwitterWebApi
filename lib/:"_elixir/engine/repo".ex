defmodule :"Elixir.Engine.repo" do
  use Ecto.Repo,
    otp_app: :twitterPheonix,
    adapter: Ecto.Adapters.Postgres
end
