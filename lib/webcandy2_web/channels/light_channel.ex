defmodule Webcandy2Web.LightChannel do
  use Phoenix.Channel

  alias Webcandy2.LightServer

  def join("light", _payload, socket) do
    {:ok, %{color: LightServer.get_color(LightServer)}, socket}
  end

  def handle_in("set_color", %{"color" => color}, socket) do
    LightServer.set_color(LightServer, color)
    broadcast!(socket, "set_color", %{color: color})

    {:noreply, socket}
  end
end
