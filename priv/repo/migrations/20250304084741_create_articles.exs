defmodule ArticleApp.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :title, :string
      add :content, :text
      add :author_name, :string
      add :published, :boolean, default: false, null: false
      add :tags, {:array, :string}
      add :published_at, :utc_datetime
      add :label, :string

      timestamps(type: :utc_datetime)
    end
  end
end
