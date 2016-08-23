defmodule Recruitbot do
  use Application
  import Supervisor.Spec, warn: false

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: Recruitbot.Supervisor]
    Supervisor.start_link(children(Mix.env), opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Recruitbot.Endpoint.config_change(changed, removed)
    :ok
  end

  defp children(:test) do
    [
      supervisor(Recruitbot.Endpoint, []),
    ]
  end
  defp children(_) do
    dj_opts = Application.get_env(:recruitbot, :dj_opts)

    [
      supervisor(Recruitbot.Endpoint, []),
      supervisor(Recruitbot.DJSupervisor, [dj_opts]),
      worker(Recruitbot.Checkin, []),
    ]
  end
end
