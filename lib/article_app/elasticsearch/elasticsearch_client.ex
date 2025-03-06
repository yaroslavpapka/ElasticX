defmodule ArticleApp.ElasticsearchCluster do
  @moduledoc """
  """

  use Elasticsearch.Cluster, otp_app: :article_app

  def get_cluster do
    start_link([])
  end
end
