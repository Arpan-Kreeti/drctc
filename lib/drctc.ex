defmodule Drctc.Server do
  use GenServer

  # API

  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args, name: __MODULE__)
  end

  def book_ticket(user, seat_no) do
    GenServer.call(__MODULE__, {:book_seat, user, seat_no})
  end

  def cancel_ticket(user, seat_no) do
    GenServer.call(__MODULE__, {:cancel_seat, user, seat_no})
  end

  def display_status(user \\ nil) do
    send(__MODULE__, {:display_seat, user})
  end

  # SERVER

  def init(_) do
    {:ok, Drctc.Seats.get()}
  end

  def handle_call({:book_seat, user, seat_no}, _from,seats) do
    case book_seat(user, seat_no, seats) do
      {:ok, seats} -> {:reply, :ok, seats}
      {:error, reason} -> {:reply, {:error, reason}, seats}
    end
  end

  def handle_call({:cancel_seat, user, seat_no},_from, seats) do
    case cancel_seat(user, seat_no, seats) do
      {:ok, seats} -> {:reply, :ok, seats}
      {:error, reason} -> {:reply, {:error, reason}, seats}
    end
  end

  def handle_info({:display_seat, user}, seats) do
    display_seat(seats, user)
    {:noreply, seats}
  end

  def terminate(_reason, seats) do
    Drctc.Seats.update(seats)
  end

  # Buissness logic

  defp display_seat(seats, user) do

    IO.inspect seats

    # seats
    # |> Enum.with_index()
    # |> Enum.each(fn {seat, index} ->
    #   case seat do
    #     nil -> IO.puts("#{index + 1}: _")
    #     ^user -> IO.puts("#{index + 1}: #{user}")
    #     _ -> IO.puts("#{index + 1}: X")
    #   end
    # end)
  end

  defp book_seat(user, seat_no, seats) do
    seat_no = seat_no - 1

    case Enum.at(seats, seat_no) do
      nil -> {:ok, List.replace_at(seats, seat_no, user)}
      _ -> {:error, "Seat has already been booked"}
    end
  end

  defp cancel_seat(user, seat_no, seats) do
    seat_no = seat_no - 1

    case Enum.at(seats, seat_no) do
      nil ->
        {:error, "Seat is not booked"}

      xuser ->
        case xuser do
          ^user -> {:ok, List.replace_at(seats, seat_no, nil)}
          _ -> {:error, "Cannot cancel other user seat"}
        end
    end
  end
end
