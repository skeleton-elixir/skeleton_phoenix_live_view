defmodule Skeleton.Phoenix.LiveViewTest do
  use ExUnit.Case
  doctest SkeletonPhoenixLiveView

  test "greets the world" do
    assert SkeletonPhoenixLiveView.hello() == :world
  end
end
