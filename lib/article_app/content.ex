defmodule ArticleApp.Content do
  @moduledoc """
  The Content context.
  """

  import Ecto.Query, warn: false
  alias ArticleApp.Repo

  alias ArticleApp.Content.Article
  alias ArticleApp.Elasticsearch.Service
  alias ArticleApp.ElasticsearchCluster
  @doc """
  Returns the list of articles.

  ## Examples

      iex> list_articles()
      [%Article{}, ...]

  """
  def list_articles do
    case search_articles() do
      {:ok, [first | rest]} -> [first | rest]
      _ -> []
    end
  end
  @doc """
  Gets a single article.

  Raises `Ecto.NoResultsError` if the Article does not exist.

  ## Examples

      iex> get_article!(123)
      %Article{}

      iex> get_article!(456)
      ** (Ecto.NoResultsError)

  """
  def get_article!(id) do
    case get_article_from_elastic(id) do
      {:ok, article} -> article
      _ -> Repo.get!(Article, id)
    end
  end

  @doc """
  Creates a article.

  ## Examples

      iex> create_article(%{field: value})
      {:ok, %Article{}}

      iex> create_article(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_article(attrs) do
    %Article{}
    |> Article.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, article} ->
        ArticleApp.Elasticsearch.Service.index_article(article)
        {:ok, article}

      error -> error
    end
  end

  @doc """
  Updates a article.

  ## Examples

      iex> update_article(article, %{field: new_value})
      {:ok, %Article{}}

      iex> update_article(article, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_article(%Article{} = article, attrs) do
    article
    |> Article.changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, updated_article} ->
        Service.index_article(updated_article)
        {:ok, updated_article}

      error -> error
    end
  end

  @doc """
  Deletes a article.

  ## Examples

      iex> delete_article(article)
      {:ok, %Article{}}

      iex> delete_article(article)
      {:error, %Ecto.Changeset{}}

  """
  def delete_article(%Article{} = article) do
    Repo.delete(article)
    Service.delete_article(article.id)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking article changes.

  ## Examples

      iex> change_article(article)
      %Ecto.Changeset{data: %Article{}}

  """
  def change_article(%Article{} = article, attrs \\ %{}) do
    Article.changeset(article, attrs)
  end

  def search_articles(author, tag, content) do
    query = %{
      query: %{
        bool: %{
          must: build_search_query(author, tag, content)
        }
      },
      size: 10_000
    }

    case Elasticsearch.post(ElasticsearchCluster, "/articles/_search", query) do
      {:ok, %{"hits" => %{"hits" => hits}}} ->
        Enum.map(hits, &parse_article/1)

      {:error} ->
        []
    end
  end

  defp build_search_query(author, tag, content) do
    conditions =
      [
        build_match_condition("author_name", author),
        build_match_condition("tags", tag),
        build_match_condition("content", content)
      ]
      |> Enum.reject(&is_nil/1)

    if conditions == [], do: %{match_all: {}}, else: %{bool: %{must: conditions}}
  end

  defp build_match_condition("tags", value), do: %{wildcard: %{"tags" => "*#{value}*"}}
  defp build_match_condition(_, ""), do: nil
  defp build_match_condition(field, value), do: %{match_phrase_prefix: %{field => value}}

  defp search_articles do
    query = %{
      query: %{match_all: %{}},
      size: 100
    }

    case Elasticsearch.post(ElasticsearchCluster, "/articles/_search", query) do
      {:ok, %{"hits" => %{"hits" => hits}}} ->
        articles = Enum.map(hits, &parse_article/1)
        {:ok, articles}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp get_article_from_elastic(id) do
    case Elasticsearch.get(ElasticsearchCluster, "/articles/_doc/#{id}") do
      {:ok, %{"_source" => source}} ->
        {:ok, parse_article(source)}

      {:error, %Elasticsearch.Exception{status: 404}} ->
        {:error, :not_found}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp parse_article(%{"_source" => source}), do: parse_article(source)

  defp parse_article(source) do
    %Article{
      id: source["id"],
      title: source["title"],
      content: source["content"],
      author_name: source["author_name"],
      published: source["published"],
      tags: source["tags"] || [],
      published_at: source["published_at"],
      inserted_at: source["inserted_at"],
      updated_at: source["updated_at"],
      label: source["label"]
    }
  end
end
