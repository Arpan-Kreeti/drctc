defmodule Drctc.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Drctc.Seats, Application.get_env(:drctc, :initial_seats)},
      {Drctc.Server, nil}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :rest_for_one, name: Drctc.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
