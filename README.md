# Sobre o Skeleton Phoenix Live View

O Skeleton Phoenix Live View é um facilitador para criação de live em sua aplicação, permitindo que você tenha os métodos enxutos e auto explicativos.

## Instalação

```elixir
# mix.exs

def deps do
  [
    {:skeleton_phoenix_live_view, "~> 1.0.1"}
  ]
end
```

```elixir
# lib/app_web/live_view.ex

defmodule AppWeb.LiveView do
  @behaviour Skeleton.Phoenix.LiveView

  defmacro __using__(_) do
    quote do
      use Skeleton.Phoenix.LiveView, live_view: AppWeb.LiveView
    end
  end

  def is_authenticated(socket), do: socket.assigns[:current_user]
end
```

```elixir
# lib/app_web/live_view.ex
defmodule AppWeb do
  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {AppWeb.LayoutView, "live.html"}

      use AppWeb.LiveView

      unquote(view_helpers())
    end
  end
end
```

## Criando os lives

```elixir
# lib/app_web/live/user_controller.ex

defmodule AppWeb.User.NewLive do
  use AppWeb, :live_view

  alias App.Accounts

  @impl true
  def mount(_params, %{"current_user_id" => nil}, socket) do
    {:ok, redirect(socket, to: Routes.session_path(socket, :new))}
  end

  @impl true
  def mount(_params, session, socket) do
    assign_initial_state(socket)
  end

  # Create

  @impl true
  def handle_event("create", %{"user" => params}, socket) do
    socket
    |> resolve(fn socket ->
      case Accounts.create_user(params) do
        {:ok, _user} ->
          {:noreply,
           socket
           |> put_flash(:info, "Usuário criado com sucesso")
           |> push_redirect(to: Routes.live_path(socket, AppWeb.Home.IndexLive))}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, changeset: changeset)}
      end
    end)
  end

  # Assign initial state

  defp assign_initial_state(socket) do
    changeset = Accounts.user_changeset()

    assign(socket, changeset: changeset)
  end
end
```