defmodule ArticleApp.Elasticsearch.SearchTest do
  use ExUnit.Case
  alias ArticleApp.Elasticsearch.Search

  test "search_articles returns search results" do
    query = "Test"
    assert {:ok, response} = Search.search_articles(query)
    assert Map.has_key?(response, "hits")
  end
end
