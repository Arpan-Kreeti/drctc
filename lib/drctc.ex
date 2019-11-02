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

  def display_status do
    send(__MODULE__, :display_seat)
  end

  # SERVER

  def init(_) do
    welcome()
    {:ok, Drctc.Seats.get()}
  end

  def handle_call({:book_seat, user, seat_no}, _from, seats) do
    case book_seat(user, seat_no, seats) do
      {:ok, seats} -> {:reply, :ok, seats}
      {:error, reason} -> {:reply, {:error, reason}, seats}
    end
  end

  def handle_call({:cancel_seat, user, seat_no}, _from, seats) do
    case cancel_seat(user, seat_no, seats) do
      {:ok, seats} -> {:reply, :ok, seats}
      {:error, reason} -> {:reply, {:error, reason}, seats}
    end
  end

  def handle_info(:display_seat, seats) do
    display_seat(seats)
    {:noreply, seats}
  end

  def terminate(_reason, seats) do
    Drctc.Seats.update(seats)
  end

  # Buissness logic

  defp display_seat(seats) do
    IO.inspect(seats)
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
      nil -> raise "Seat is not booked"

      xuser ->
        case xuser do
          ^user -> {:ok, List.replace_at(seats, seat_no, nil)}
          _ -> raise "Cannot cancel other user's seat"
        end
    end
  end

  defp welcome do
    IO.puts("
Welcome to....

DDDDDDDDDDDDD             RRRRRRRRRRRRRRRRR                CCCCCCCCCCCCC     TTTTTTTTTTTTTTTTTTTTTTT             CCCCCCCCCCCCC
D::::::::::::DDD          R::::::::::::::::R            CCC::::::::::::C     T:::::::::::::::::::::T          CCC::::::::::::C
D:::::::::::::::DD        R::::::RRRRRR:::::R         CC:::::::::::::::C     T:::::::::::::::::::::T        CC:::::::::::::::C
DDD:::::DDDDD:::::D       RR:::::R     R:::::R       C:::::CCCCCCCC::::C     T:::::TT:::::::TT:::::T       C:::::CCCCCCCC::::C
  D:::::D    D:::::D        R::::R     R:::::R      C:::::C       CCCCCC     TTTTTT  T:::::T  TTTTTT      C:::::C       CCCCCC
  D:::::D     D:::::D       R::::R     R:::::R     C:::::C                           T:::::T             C:::::C
  D:::::D     D:::::D       R::::RRRRRR:::::R      C:::::C                           T:::::T             C:::::C
  D:::::D     D:::::D       R:::::::::::::RR       C:::::C                           T:::::T             C:::::C
  D:::::D     D:::::D       R::::RRRRRR:::::R      C:::::C                           T:::::T             C:::::C
  D:::::D     D:::::D       R::::R     R:::::R     C:::::C                           T:::::T             C:::::C
  D:::::D     D:::::D       R::::R     R:::::R     C:::::C                           T:::::T             C:::::C
  D:::::D    D:::::D        R::::R     R:::::R      C:::::C       CCCCCC             T:::::T              C:::::C       CCCCCC
DDD:::::DDDDD:::::D       RR:::::R     R:::::R       C:::::CCCCCCCC::::C           TT:::::::TT             C:::::CCCCCCCC::::C
D:::::::::::::::DD        R::::::R     R:::::R        CC:::::::::::::::C           T:::::::::T              CC:::::::::::::::C
D::::::::::::DDD          R::::::R     R:::::R          CCC::::::::::::C           T:::::::::T                CCC::::::::::::C
DDDDDDDDDDDDD             RRRRRRRR     RRRRRRR             CCCCCCCCCCCCC           TTTTTTTTTTT                   CCCCCCCCCCCCC


Server running....
")
  end
end
