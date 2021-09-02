defmodule Webcandy2.LightServer do
  use GenServer

  require Logger

  # TODO: Frontend sets this to HSV, mirror that here
  defstruct color: "#FFFFFF"

  def start_link(_) do
    Logger.info("Creating light server...")

    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  ## API

  def get_color(server) do
    GenServer.call(server, :get_color)
  end

  def set_color(server, color) do
    GenServer.cast(server, {:set_color, color})
  end

  ## Callbacks

  @impl true
  def init(_) do
    {:ok, %__MODULE__{}}
  end

  @impl true
  def handle_call(:get_color, _from, state) do
    {:reply, state.color, state}
  end

  @impl true
  def handle_cast({:set_color, color}, state) do
    {:noreply, %{state | color: color}}
  end
end
