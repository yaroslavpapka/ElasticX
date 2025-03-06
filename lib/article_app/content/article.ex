defmodule ArticleApp.Content.Article do
  use Ecto.Schema
  import Ecto.Changeset

  schema "articles" do
    field :label, :string
    field :title, :string
    field :content, :string
    field :tags, {:array, :string}
    field :author_name, :string
    field :published, :boolean, default: false
    field :published_at, :utc_datetime

    field :tags_string, :string, virtual: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [
      :title,
      :content,
      :author_name,
      :published,
      :tags,
      :published_at,
      :label,
      :tags_string
    ])
    |> validate_required([:title, :content, :author_name, :published, :label])
    |> convert_tags()
    |> maybe_set_published_at()
  end

  defp convert_tags(changeset) do
    if tags_str = get_change(changeset, :tags_string) do
      tags =
        tags_str
        |> String.split(",")
        |> Enum.map(&String.trim/1)
        |> Enum.reject(&(&1 == ""))
      put_change(changeset, :tags, tags)
    else
      changeset
    end
  end

  defp maybe_set_published_at(changeset) do
    if get_field(changeset, :published) == true do
      current_time = DateTime.utc_now() |> DateTime.truncate(:second)
      put_change(changeset, :published_at, current_time)
    else
      put_change(changeset, :published_at, nil)
    end
  end
end
