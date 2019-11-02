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

# welcome = "

# DDDDDDDDDDDDD             RRRRRRRRRRRRRRRRR                CCCCCCCCCCCCC     TTTTTTTTTTTTTTTTTTTTTTT             CCCCCCCCCCCCC
# D::::::::::::DDD          R::::::::::::::::R            CCC::::::::::::C     T:::::::::::::::::::::T          CCC::::::::::::C
# D:::::::::::::::DD        R::::::RRRRRR:::::R         CC:::::::::::::::C     T:::::::::::::::::::::T        CC:::::::::::::::C
# DDD:::::DDDDD:::::D       RR:::::R     R:::::R       C:::::CCCCCCCC::::C     T:::::TT:::::::TT:::::T       C:::::CCCCCCCC::::C
#   D:::::D    D:::::D        R::::R     R:::::R      C:::::C       CCCCCC     TTTTTT  T:::::T  TTTTTT      C:::::C       CCCCCC
#   D:::::D     D:::::D       R::::R     R:::::R     C:::::C                           T:::::T             C:::::C
#   D:::::D     D:::::D       R::::RRRRRR:::::R      C:::::C                           T:::::T             C:::::C
#   D:::::D     D:::::D       R:::::::::::::RR       C:::::C                           T:::::T             C:::::C
#   D:::::D     D:::::D       R::::RRRRRR:::::R      C:::::C                           T:::::T             C:::::C
#   D:::::D     D:::::D       R::::R     R:::::R     C:::::C                           T:::::T             C:::::C
#   D:::::D     D:::::D       R::::R     R:::::R     C:::::C                           T:::::T             C:::::C
#   D:::::D    D:::::D        R::::R     R:::::R      C:::::C       CCCCCC             T:::::T              C:::::C       CCCCCC
# DDD:::::DDDDD:::::D       RR:::::R     R:::::R       C:::::CCCCCCCC::::C           TT:::::::TT             C:::::CCCCCCCC::::C
# D:::::::::::::::DD        R::::::R     R:::::R        CC:::::::::::::::C           T:::::::::T              CC:::::::::::::::C
# D::::::::::::DDD          R::::::R     R:::::R          CCC::::::::::::C           T:::::::::T                CCC::::::::::::C
# DDDDDDDDDDDDD             RRRRRRRR     RRRRRRR             CCCCCCCCCCCCC           TTTTTTTTTTT                   CCCCCCCCCCCCC

# "
