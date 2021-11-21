defmodule Skeleton.Phoenix.LiveView do
  import Phoenix.LiveView

  # Callbacks

  @callback is_authenticated(Phoenix.LiveView.Socket.t()) :: Boolean.t()
  @callback fallback(Phoenix.LiveView.Socket.t(), any) :: Phoenix.LiveView.Socket.t()

  defmacro __using__(opts) do
    alias Skeleton.Phoenix.LiveView

    quote do
      @live_view unquote(opts[:live_view]) || raise("Live view required")

      # Ensure authenticated

      def ensure_authenticated({:error, socket, error}), do: {:error, socket, error}
      def ensure_authenticated(socket), do: LiveView.do_ensure_authenticated(@live_view, socket)

      # Ensure not authenticated

      def ensure_not_authenticated({:error, socket, error}), do: {:error, socket, error}

      def ensure_not_authenticated(socket),
        do: LiveView.do_ensure_not_authenticated(@live_view, socket)

      # Assign value

      def assign_value(value, %Phoenix.LiveView.Socket{} = socket, key),
        do: assign(socket, key, value)

      # Step

      def step({:error, socket, error}, _), do: {:error, socket, error}
      def step(socket, callback), do: callback.(socket)

      def step({:error, socket, error}, :connected, _callback), do: {:error, socket, error}

      def step(socket, :connected, callback),
        do: LiveView.step(:connected, socket, callback)

      def step({:error, socket, error}, :disconnected, _callback), do: {:error, socket, error}

      def step(socket, :disconnected, callback),
        do: LiveView.step(:disconnected, socket, callback)

      # Resolve

      def resolve({:error, socket, error}), do: @live_view.fallback(socket, error)
      def resolve(socket, callback), do: LiveView.resolve(socket, callback)
      def resolve(socket), do: {:ok, socket}
    end
  end

  # Do ensure authenticated

  def do_ensure_authenticated(live_view, socket) do
    if live_view.is_authenticated(socket) do
      socket
    else
      unauthorized(socket)
    end
  end

  # Do ensure not authenticated

  def do_ensure_not_authenticated(live_view, socket) do
    if live_view.is_authenticated(socket) do
      unauthorized(socket)
    else
      socket
    end
  end

  # Return unauthorized

  def unauthorized(socket) do
    {:error, socket, :unauthorized}
  end

  # Step

  def step(:connected, socket, callback) do
    if connected?(socket) do
      callback.(socket)
    else
      socket
    end
  end

  def step(:disconnected, socket, callback) do
    if connected?(socket) do
      socket
    else
      callback.(socket)
    end
  end

  # Resolve

  def resolve(socket, callback) do
    if connected?(socket) do
      {:ok, callback.(socket)}
    else
      {:ok, socket}
    end
  end
end
