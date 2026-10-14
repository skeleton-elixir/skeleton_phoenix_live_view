defmodule Skeleton.Phoenix.LiveViewTest do
  use ExUnit.Case
  doctest SkeletonPhoenixLiveView

  alias Phoenix.LiveView.Socket

  defmodule FakeLiveView do
    @behaviour Skeleton.Phoenix.LiveView

    @impl true
    def is_authenticated(_socket), do: true

    @impl true
    def fallback(socket, error), do: Phoenix.Component.assign(socket, :fallback_error, error)
  end

  defmodule Pipeline do
    import Phoenix.Component, only: [assign: 3]
    use Skeleton.Phoenix.LiveView, live_view: FakeLiveView
  end

  setup do
    {:ok, socket: %Socket{}}
  end

  describe "ok/1" do
    test "aplica o fallback quando o pipeline falhou", %{socket: socket} do
      assert {:ok, %Socket{assigns: %{fallback_error: :forbidden}}} =
               Pipeline.ok({:error, socket, :forbidden})
    end

    test "devolve o socket quando o pipeline foi pulado", %{socket: socket} do
      assert {:ok, ^socket} = Pipeline.ok({:skip, socket})
    end

    test "devolve o socket quando o pipeline terminou", %{socket: socket} do
      assert {:ok, ^socket} = Pipeline.ok(socket)
    end
  end

  describe "noreply/1" do
    test "aplica o fallback quando o pipeline falhou", %{socket: socket} do
      result =
        socket
        |> Pipeline.step(fn socket -> {:error, socket, :forbidden} end)
        |> Pipeline.noreply()

      assert {:noreply, %Socket{assigns: %{fallback_error: :forbidden}}} = result
    end

    test "devolve o socket quando o pipeline foi pulado", %{socket: socket} do
      assert {:noreply, ^socket} = Pipeline.noreply({:skip, socket})
    end

    test "devolve o socket quando o pipeline terminou", %{socket: socket} do
      assert {:noreply, ^socket} = Pipeline.noreply(socket)
    end
  end

  describe "resolve/1" do
    test "aplica o fallback quando o pipeline falhou", %{socket: socket} do
      assert %Socket{assigns: %{fallback_error: :forbidden}} =
               Pipeline.resolve({:error, socket, :forbidden})
    end
  end
end
