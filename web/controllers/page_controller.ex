defmodule Recruitbot.PageController do
  use Recruitbot.Web, :controller

  def index(conn, _params) do
    {:ok, hostname} = :inet.gethostname
    render conn, "index.html", hostname: hostname
  end
end
