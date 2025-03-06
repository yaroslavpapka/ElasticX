defmodule ArticleApp.ContentFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ArticleApp.Content` context.
  """

  @doc """
  Generate a article.
  """
  def article_fixture(attrs \\ %{}) do
    random_author_name = "Author #{:rand.uniform(1000)}"
    random_content = "Content #{:rand.uniform(1000)}"
    random_label = "Label #{:rand.uniform(1000)}"
    random_title = "Title #{:rand.uniform(1000)}"

    {:ok, article} =
      attrs
      |> Enum.into(%{
        author_name: random_author_name,
        content: random_content,
        label: random_label,
        published: true,
        tags: ["option1", "option2"],
        title: random_title
      })
      |> ArticleApp.Content.create_article()

    article
  end
end
