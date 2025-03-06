defmodule ArticleApp.Elasticsearch.Index do
  alias ArticleApp.ElasticsearchCluster
  require Logger

  @index_name "articles"

  def create_index do
    case check_index_exists() do
      true ->
        Logger.info("Elasticsearch index '#{@index_name}' already exists. Skipping creation.")

      false ->
        Logger.info("Creating Elasticsearch index '#{@index_name}'...")
        do_create_index()
    end
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

  defp check_index_exists do
    case Elasticsearch.get(ElasticsearchCluster, "/#{@index_name}") do
      {:ok, _response} -> true
      {:error, %Elasticsearch.Exception{status: 404}} -> false
      {:error, _} ->
        false
    end
  end

  defp do_create_index do
    body = %{
      settings: %{
        number_of_shards: 1,
        number_of_replicas: 1
      },
      mappings: %{
        properties: %{
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

    case Elasticsearch.put(ElasticsearchCluster, "/#{@index_name}", body) do
      {:ok, _response} ->
        Logger.info("Elasticsearch index '#{@index_name}' created successfully.")
      {:error, reason} ->
        Logger.error("Failed to create Elasticsearch index: #{inspect(reason)}")
    end
  end
end
