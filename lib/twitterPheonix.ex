defmodule TwitterPheonix do
  @moduledoc """
  TwitterPheonix keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def start() do
    import Supervisor.Spec, warn: false
    # List all child processes to be supervised
    children = [
      TwitterPheonix.Repo,
    ]
    Supervisor.start_link(children)

  end
  #TwitterPheonix.start()

end
