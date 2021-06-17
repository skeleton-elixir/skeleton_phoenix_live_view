defmodule Skeleton.Phoenix.LiveView do
  # Callbacks

  @callback is_authenticated(Plug.Socket.t) :: Boolean.t
  @callback fallback(Plug.Conn.t()) :: Plug.Conn.t()

  defmacro __using__(opts) do
    alias Skeleton.Phoenix.LiveView

    quote do
      @live_view unquote(opts[:live_view]) || raise("Live view required")

      # Ensure authenticated

      def ensure_authenticated({:error, socket, error}), do: {:error, socket, error}
      def ensure_authenticated(socket), do: LiveView.do_ensure_authenticated(@live_view, socket)

      # Ensure not authenticated

      def ensure_not_authenticated({:error, socket, error}), do: {:error, socket, error}
      def ensure_not_authenticated(socket), do: LiveView.do_ensure_not_authenticated(@live_view, socket)

      # Resolve

      def resolve({:error, socket, error}, _), do: @live_view.fallback(socket, error)
      def resolve(socket, callback), do: callback.(socket)
    end
  end

  # Do ensure authenticated

  def do_ensure_authenticated(live_view, socket) do
    if live_view.is_authenticated(socket) do
      success(socket)
    else
      unauthorized(socket)
    end
  end

  # Do ensure not authenticated

  def do_ensure_not_authenticated(live_view, socket) do
    if live_view.is_authenticated(socket) do
      unauthorized(socket)
    else
      success(socket)
    end
  end

  # Return unauthorized

  def unauthorized(socket) do
    {:error, socket, :unauthorized}
  end

  # Retorn success

  def success(socket) do
    socket
  end
end
