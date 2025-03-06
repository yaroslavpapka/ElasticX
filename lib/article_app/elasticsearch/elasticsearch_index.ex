defmodule ArticleApp.Elasticsearch.Index do
  alias ArticleApp.ElasticsearchCluster
  require Logger

  @index_name "articles"
  
  @mapping %{
    "settings" => %{
      "number_of_shards" => 1,
      "number_of_replicas" => 0
    },
    "mappings" => %{
      "properties" => %{
        "id" => %{"type" => "integer"},
        "title" => %{"type" => "text"},
        "content" => %{"type" => "text"},
        "author_name" => %{"type" => "text"},
        "published" => %{"type" => "boolean"},
        "tags" => %{"type" => "keyword"},
        "published_at" => %{"type" => "date"},
        "inserted_at" => %{"type" => "date"},
        "updated_at" => %{"type" => "date"},
        "label" => %{"type" => "keyword"}
      }
    }
  }

  def create_index do
    case Elasticsearch.get(ElasticsearchCluster, "/#{@index_name}") do
      {:ok, _} -> {:error, "Index already exists"}
      _ -> Elasticsearch.put(ElasticsearchCluster, "/#{@index_name}", @mapping)
    end
  end

  def delete_index do
    Elasticsearch.delete(ElasticsearchCluster, "/#{@index_name}")
  end

  def delete_all_documents do
    Logger.info("Deleting all documents from Elasticsearch index '#{@index_name}'...")

    case Elasticsearch.post(ElasticsearchCluster, "/#{@index_name}/_delete_by_query", %{
      query: %{
        match_all: %{}
      }
    }) do
      {:ok, _response} ->
        Logger.info("All documents deleted successfully from '#{@index_name}'.")

      {:error, reason} ->
        Logger.error("Failed to delete documents from Elasticsearch: #{inspect(reason)}")
    end
  end
end
