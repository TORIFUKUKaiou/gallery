defmodule Gallery.Repo.Migrations.CreatePictures do
  use Ecto.Migration

  def change do
    create table(:pictures) do
      add :url, :string, null: false

      timestamps()
    end
  end
end
