defmodule ArticleApp.Elasticsearch.Search do
  alias ArticleApp.ElasticsearchCluster

  @index "articles"

  def search_articles(query) do
    body = %{
      query: %{
        multi_match: %{
          query: query,
          fields: ["title", "content", "author_name"]
        }
      }
    }

    Elasticsearch.post(ElasticsearchCluster, "/#{@index}/_search", body)
  end
end
