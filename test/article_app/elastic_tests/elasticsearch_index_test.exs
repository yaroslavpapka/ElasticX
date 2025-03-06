defmodule ArticleApp.Elasticsearch.IndexTest do
  use ExUnit.Case
  alias ArticleApp.Elasticsearch.Index

  test "create_index does not create index if it already exists" do
    assert Index.create_index() == :ok
  end

end
