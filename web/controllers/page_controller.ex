defmodule Recruitbot.PageController do
  use Recruitbot.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
