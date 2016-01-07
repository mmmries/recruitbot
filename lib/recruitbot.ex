defmodule Recruitbot do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    dj_opts = Application.get_env(:recruitbot, :dj_opts)

    children = [
      # Start the endpoint when the application starts
      supervisor(Recruitbot.Endpoint, []),
      supervisor(Recruitbot.DJSupervisor, [dj_opts]),
      worker(Recruitbot.Checkin, []),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Recruitbot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Recruitbot.Endpoint.config_change(changed, removed)
    :ok
  end
end
