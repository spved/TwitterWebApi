defmodule TwitterPheonixWeb.PageController do
  use TwitterPheonixWeb, :controller


    def index(conn, _params) do
      render(conn, "index.html")
    end

    def displayText(conn, _params) do
      render(conn, "index.html")
    end

    def show(conn, %{"id" => id}) do
      #user = Repo.get(User, id)
      #render(conn, "show.html", user: user)
      name = "VRASHAKHS"
      render(conn, "test.html", name: id)

    end
end
