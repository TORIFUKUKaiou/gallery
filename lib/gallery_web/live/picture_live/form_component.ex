defmodule GalleryWeb.PictureLive.FormComponent do
  use GalleryWeb, :live_component

  alias Gallery.Art
  alias Gallery.Art.Picture

  @impl true
  def mount(socket) do
    {:ok, allow_upload(socket, :photo, accept: ~w(.png .jpg .jpeg))}
  end

  @impl true
  def update(%{picture: picture} = assigns, socket) do
    changeset = Art.change_picture(picture)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("save", _params, socket) do
    picture = put_photo_url(socket, %Picture{})

    case Art.create_picture(picture, %{}, &consume_photo(socket, &1)) do
      {:ok, _picture} ->
        {:noreply,
         socket
         |> put_flash(:info, "Picture created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("cancel-entry", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photo, ref)}
  end

  defp ext(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    ext
  end

  defp put_photo_url(socket, %Picture{} = picture) do
    {completed, []} = uploaded_entries(socket, :photo)

    urls =
      for entry <- completed do
        Routes.static_path(socket, "/uploads/#{entry.uuid}.#{ext(entry)}")
      end

    url = Enum.at(urls, 0)

    %Picture{picture | url: url}
  end

  def consume_photo(socket, %Picture{} = picture) do
    consume_uploaded_entries(socket, :photo, fn meta, entry ->
      dest = Path.join("priv/static/uploads", "#{entry.uuid}.#{ext(entry)}")
      File.cp!(meta.path, dest)
    end)

    {:ok, picture}
  end
end
