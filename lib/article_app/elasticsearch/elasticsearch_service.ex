defmodule ArticleApp.Elasticsearch.Service do
  alias ArticleApp.ElasticsearchCluster
  alias ArticleApp.Content.Article

  @index "articles"

  def index_article(%Article{} = article) do
    body = %{
      id: article.id,
      title: article.title,
      content: article.content,
      author_name: article.author_name,
      published: article.published,
      tags: article.tags,
      published_at: article.published_at,
      inserted_at: article.inserted_at,
      updated_at: article.updated_at,
      label: article.label
    }

    Elasticsearch.put(ElasticsearchCluster, "/#{@index}/_doc/#{article.id}", body)
  end


  def delete_article(article_id) do
    Elasticsearch.delete(ElasticsearchCluster, "/#{@index}/_doc/#{article_id}")
  end
end
