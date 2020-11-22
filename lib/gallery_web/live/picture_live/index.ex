defmodule GalleryWeb.PictureLive.Index do
  use GalleryWeb, :live_view

  alias Gallery.Art
  alias Gallery.Art.Picture

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, list_of_pictures: list_of_pictures())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Picture")
    |> assign(:picture, %Picture{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Pictures")
    |> assign(:picture, nil)
  end

  defp list_of_pictures do
    Art.list_pictures() |> Enum.chunk_every(3)
  end
end
