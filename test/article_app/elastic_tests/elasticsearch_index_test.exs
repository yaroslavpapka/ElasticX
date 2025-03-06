defmodule ArticleApp.Elasticsearch.IndexTest do
  use ExUnit.Case
  alias ArticleApp.Elasticsearch.Index

  test "create_index if it already exists" do
    assert Index.create_index() == {:error, "Index already exists"}
  end

end
