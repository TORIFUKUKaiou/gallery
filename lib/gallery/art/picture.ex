defmodule Gallery.Art.Picture do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pictures" do
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(picture, attrs) do
    picture
    |> cast(attrs, [:url])
    |> validate_required([:url])
  end
end
