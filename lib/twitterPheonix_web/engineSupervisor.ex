defmodule TwitterPheonixWeb.Twitter.Supervisor do
  use Supervisor

  def start_link(init_arg) do
    IO.puts "Here"
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)

  end

  @impl true
  def init(_init_arg) do
    IO.puts "init"
    children = [
      #create boss using Supervisor
      {TwitterPheonixWeb.Twitter.Engine, []}
    ]
    IO.puts "init_b"
    Supervisor.init(children, strategy: :one_for_one)
    #IO.puts "init End"
  end

end
