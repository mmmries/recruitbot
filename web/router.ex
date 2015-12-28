defmodule Recruitbot.Router do
  use Recruitbot.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
  end

  scope "/", Recruitbot do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end
end
