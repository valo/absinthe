defmodule Absinthe.Subscription.ProxySupervisor do
  @moduledoc false

  use Supervisor

  def start_link(pubsub, registry, pool_size) do
    Supervisor.start_link(__MODULE__, {pubsub, registry, pool_size})
  end

  def init({pubsub, _registry, pool_size}) do
    children =
      for shard <- 1..pool_size do
        worker(Absinthe.Subscription.Proxy, [pubsub, shard], id: shard)
      end

    supervise(children, strategy: :one_for_one)
  end
end
