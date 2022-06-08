defmodule CrackleAxe.Game do
  alias CrackleAxe.Data.{Board, Player}
  use TypedStruct
  use GenServer

  @typep direction() :: :up | :down | :left | :right

  typedstruct do
    field :board, Board.t()
    field :player_id, Board.Entity.id()
  end

  @doc """
  Starts the game server.
  """
  @spec start_link() :: {:ok, pid()}
  def start_link(), do: GenServer.start_link(__MODULE__, [])

  @doc """
  Moves the player in the specified direction.
  """
  @spec move_player(pid(), direction()) :: :ok
  def move_player(game, direction) do
    GenServer.cast(game, {:move_player, direction})
  end

  @doc """
  Returns the game's board.
  """
  @spec get_board(pid()) :: Board.t()
  def get_board(game) do
    GenServer.call(game, :get_board)
  end

  @impl true
  def init(_) do
    {id, board} = Board.new("Game", 20, 10) |> Board.place_entity(Player.new(), 0, 0)
    {:ok, %__MODULE__{board: board, player_id: id}}
  end

  @impl true
  def handle_cast({:move_player, direction}, state) do
    {x, y} = handle_direction(direction)

    {:noreply,
     %__MODULE__{
       player_id: state.player_id,
       board: Board.move_entity(state.board, state.player_id, x, y)
     }}
  end

  defp handle_direction(direction) do
    case direction do
      :up -> {0, -1}
      :down -> {0, 1}
      :left -> {-1, 0}
      :right -> {1, 0}
    end
  end

  @impl true
  def handle_call(:get_board, _from, state) do
    {:reply, state.board, state}
  end
end
