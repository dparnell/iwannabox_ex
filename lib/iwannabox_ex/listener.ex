defmodule IwannaboxEx.Listener do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: :iwannabox_listener)
  end

  def init(_params) do
    {:ok, account} = IwannaboxEx.Client.account()
    {:ok, socket} = IwannaboxEx.Socket.start_link()
    {:ok, channel} = PhoenixChannelClient.channel(IwannaboxEx.Channel, socket: IwannaboxEx.Socket, topic: "user:#{account["id"]}")
    IwannaboxEx.Channel.join(%{})

    {:ok, {socket, channel}}
  end

end
