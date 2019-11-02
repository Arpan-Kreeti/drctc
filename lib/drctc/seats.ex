defmodule Drctc.Seats do
  use GenServer

  # API

  def start_link(initial_seats) do
    GenServer.start_link(__MODULE__, initial_seats, name: __MODULE__)
  end

  def get() do
    GenServer.call(__MODULE__, {:get})
  end

  def update(new_seats) do
    GenServer.cast(__MODULE__, {:update, new_seats})
  end

  # SERVER

  def init(initial_seats) do
    {:ok, initial_seats}
  end

  def handle_call({:get}, _from, seats) do
    {:reply, seats, seats}
  end

  def handle_cast({:update, new_seats}, _seats) do
    {:noreply, new_seats}
  end
end
