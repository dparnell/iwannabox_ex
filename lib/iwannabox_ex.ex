defmodule IwannaboxEx do
  use Application

  @moduledoc """
  Documentation for IwannaboxEx.
  """
  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(IwannaboxEx.Listener, [])
    ]

    opts = [strategy: :one_for_one, name: IwannaboxEx.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
