# 🚀 ElasticSearchProject
## 📌 Overview
RedisProject is a Phoenix-based web application that utilizes PostgreSQL and Elasticsearch for managing articles. The app allows users to create, update, delete, and search articles efficiently. 📝🔍

## ✨ Features
- 📰 Article management with fields: title, author name, publish status, tags, publication date, creation date, update date, and label (URL to article).
- 🔎 Search functionality via Elasticsearch (by author or full-text search).
- 🛢️ PostgreSQL and Elasticsearch integration.
- 🎨 Modal-based UI for creating, updating, and deleting articles.
[![Demo Video](https://img.youtube.com/vi/I5GdriL-PRo/maxresdefault.jpg)](https://youtu.be/9V5CUrgC1P0)

  * Set up PostgreSQL and Elasticsearch using Docker.
  * Create an Elixir project with a page displaying a table of articles, including the author's name, publish/unpublish status, tags, publication date, creation date, update date, and a label (where we'll store the article URL).
  * Add buttons and modals for creating, updating, and deleting articles.
  * Fetch articles and implement search by author and text using Elasticsearch.
  * Ensure that create/update/delete requests affect both the database and Elasticsearch.
  * Cover the project with tests.

To start your Phoenix server:

  * Run mix deps.get
  * Run `sudo docker compose up -d` to install and setup dependencies
  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
