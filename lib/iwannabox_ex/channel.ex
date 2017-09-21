defmodule IwannaboxEx.Channel do
  use PhoenixChannelClient
  require Logger

  def handle_in(_topic, _payload, state) do
    # TODO: implement code to notify any callbacks
    # _handle_incoming(payload["action"], payload["status"], payload["instance"])

    {:noreply, state}
  end

  def handle_reply({:ok, :join, _resp, _ref}, state) do
    {:noreply, state}
  end

  def handle_reply({:ok, _topic, _resp, _ref}, state) do
    {:noreply, state}
  end

  def handle_reply({:error, _topic, _resp, _ref}, state) do
    {:noreply, state}
  end

  def handle_reply({:timeout, :join, _ref}, state) do
    {:noreply, state}
  end

  def handle_reply({:timeout, _topic, _ref}, state) do
    {:noreply, state}
  end

  def handle_close(_reason, state) do
    Process.send_after(self(), 5000, :rejoin)
    {:noreply, state}
  end

end
