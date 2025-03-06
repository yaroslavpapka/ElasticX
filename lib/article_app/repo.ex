defmodule ArticleApp.Repo do
  use Ecto.Repo,
    otp_app: :article_app,
    adapter: Ecto.Adapters.Postgres
end
