defmodule Skeleton.Phoenix.LiveView do
  import Phoenix.LiveView.Socket
  alias Skeleton.PhoenixLiveView.Config, as: LiveViewConfig
  alias Skeleton.Permission.Config, as: LiveViewConfig

  # Callbacks

  @callback is_authenticated(Plug.Socket.t) :: Boolean.t
  @callback is_not_authenticated(Plug.Socket.t) :: Boolean.t

  defmacro __using__(_) do
    alias Skeleton.Phoenix.LiveView

    quote do
      # Ensure authenticated

      def ensure_authenticated({:error, error}), do: {:error, error}
      def ensure_authenticated(socket), do: LiveView.do_ensure_authenticated(socket)

      # Ensure not authenticated

      def ensure_not_authenticated({:error, error}), do: {:error, error}
      def ensure_not_authenticated(socket), do: LiveView.do_ensure_not_authenticated(socket)

      # Check permission

      def check_permission(socket, permission_module, permission_name, _)
      def check_permission({:error, error}, _, _, _), do: {:error, error}

      def check_permission(socket, permission_module, permission_name, ctx_fun) do
        LiveView.do_check_permission(socket, permission_module, permission_name, ctx_fun)
      end

      def check_permission(socket, permission_module, permission_name) do
        LiveView.do_check_permission(socket, permission_module, permission_name, fn _, ctx -> ctx end)
      end

      # Permit params

      def permit_params({:error, error}, _, _), do: {:error, error}

      def permit_params(socket, permission_module, permission_name) do
        LiveView.do_permit_params(socket, permission_module, permission_name)
      end

      # Resolve

      def resolve({:error, error}, _), do: {:error, error}
      def resolve(socket, callback), do: callback.(socket)
    end
  end

  # Do ensure authenticated

  def do_ensure_authenticated(socket) do
    if LiveViewConfig.live_view().is_authenticated(socket) do
      success(socket)
    else
      unauthorized(socket)
    end
  end

  # Do ensure not authenticated

  def do_ensure_not_authenticated(socket) do
    if LiveViewConfig.live_view().is_authenticated(socket) do
      unauthorized(socket)
    else
      success(socket)
    end
  end

  # Do check permission

  def do_check_permission(socket, permission_module, permission_name, ctx_fun) do
    context = build_permission_context(socket, ctx_fun)

    if permission_module.check(permission_name, context) do
      success(socket)
    else
      unauthorized(socket)
    end
  end

  # Do permit params

  def do_permit_params(socket, permission_module, permission_name) do
    context = build_permission_context(socket, fn _, ctx -> ctx end)
    permitted_params = permission_module.permit(permission_name, context)
    Map.put(socket, :params, permitted_params)
  end

  # Do build context

  def build_permission_context(socket, ctx_fun) do
    ctx_fun.(socket, LiveViewConfig.permission().context(socket))
  end

  # Return unauthorized

  def unauthorized(socket) do
    {:error, :unauthorized}
  end

  # Retorn success

  def success(socket) do
    socket
  end
end
