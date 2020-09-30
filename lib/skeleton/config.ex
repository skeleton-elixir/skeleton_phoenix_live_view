defmodule Skeleton.PhoenixLiveView.Config do
  def live_view, do: config(:live_view)

  def config(key, default \\ nil) do
    Application.get_env(:skeleton_phoenix_live_view, key, default)
  end
end