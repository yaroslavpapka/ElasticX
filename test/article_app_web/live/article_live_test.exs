defmodule ArticleAppWeb.ArticleLiveTest do
  use ArticleAppWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import ArticleApp.ContentFixtures

  @valid_attrs %{title: "Test Article", content: "Some content", author_name: "John Doe", published: true, tags_string: "elixir, phoenix"}

  setup %{conn: conn} do
    article = article_fixture()
    {:ok, conn: conn, article: article}
  end

  test "renders article listing page", %{conn: conn} do
    {:ok, _view, html} = live(conn, ~p"/")
    assert html =~ "Listing Articles"
  end

  test "search filters articles", %{conn: conn, article: article} do
    {:ok, view, _html} = live(conn, ~p"/")

    view |> form("form", %{author: article.author_name}) |> render_submit()
  end

  test "opens new article modal", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/")
    view |> element("a", "New Article") |> render_click()
    assert_patch(view, ~p"/new")
  end

  test "creates a new article", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/new")
    view |> form("#article-form", article: @valid_attrs) |> render_submit()
  end

  test "edits an article", %{conn: conn, article: article} do
    {:ok, view, _html} = live(conn, ~p"/#{article.id}/edit")
    view |> form("#article-form", article: %{title: "Updated Title"}) |> render_submit()
    assert_patch(view, ~p"/")
    assert has_element?(view, "td", "Updated Title")
  end
end
