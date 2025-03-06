defmodule ArticleApp.Elasticsearch.ServiceTest do
  use ExUnit.Case
  alias ArticleApp.Elasticsearch.Service
  alias ArticleApp.Content.Article

  @article %Article{
    id: 1,
    title: "Elixir Test",
    content: "Testing in Elixir",
    author_name: "John Doe",
    published: true,
    tags: ["elixir", "testing"],
    published_at: ~U[2023-03-06 12:00:00Z],
    inserted_at: ~U[2023-03-06 12:00:00Z],
    updated_at: ~U[2023-03-06 12:00:00Z],
    label: "tech"
  }

  test "index_article successfully indexes an article" do
    assert {:ok, _} = Service.index_article(@article)
  end

  test "delete_article successfully deletes an article" do
    assert {:ok, _} = Service.delete_article(@article.id)
  end
end
