defmodule Gallery.Art do
  @moduledoc """
  The Art context.
  """

  import Ecto.Query, warn: false
  alias Gallery.Repo

  alias Gallery.Art.Picture

  @doc """
  Returns the list of pictures.

  ## Examples

      iex> list_pictures()
      [%Picture{}, ...]

  """
  def list_pictures do
    Repo.all(
      from p in Picture,
        order_by: [desc: p.inserted_at]
    )
  end

  def create_picture(picture, attrs \\ %{}, after_save) do
    picture
    |> Picture.changeset(attrs)
    |> Repo.insert()
    |> after_save(after_save)
  end

  defp after_save({:ok, picture}, func) do
    {:ok, _picture} = func.(picture)
  end

  defp after_save(error, _func), do: error

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking picture changes.

  ## Examples

      iex> change_picture(picture)
      %Ecto.Changeset{data: %Picture{}}

  """
  def change_picture(%Picture{} = picture, attrs \\ %{}) do
    Picture.changeset(picture, attrs)
  end
end
