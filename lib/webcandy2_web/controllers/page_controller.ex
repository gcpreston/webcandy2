defmodule Webcandy2Web.PageController do
  use Webcandy2Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
