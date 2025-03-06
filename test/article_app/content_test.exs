defmodule ArticleApp.ContentTest do
  use ArticleApp.DataCase, async: true

  alias ArticleApp.Content
  alias ArticleApp.Content.Article
  alias ArticleApp.ContentFixtures

  describe "get_article!/1" do
    test "returns the article with given id" do
      article = ContentFixtures.article_fixture()
      article = Content.get_article!(article.id)

      assert Content.get_article!(article.id) == article
    end

    test "raises Ecto.NoResultsError if the article does not exist" do
      assert_raise Ecto.NoResultsError, fn ->
        Content.get_article!(12345)
      end
    end
  end

  describe "create_article/1" do
    test "creates an article with valid attributes" do
      valid_attrs = %{
        title: "Test Title",
        content: "Test Content",
        author_name: "Author",
        tags: ["test"],
        published: true,
        label: "Test Label",
      }

      assert {:ok, %Article{} = article} = Content.create_article(valid_attrs)
      assert article.title == valid_attrs[:title]
      assert article.content == valid_attrs[:content]
    end

    test "returns error changeset with invalid attributes" do
      invalid_attrs = %{}

      assert {:error, %Ecto.Changeset{}} = Content.create_article(invalid_attrs)
    end
  end

  describe "update_article/2" do
    test "updates the article with valid data" do
      article = ContentFixtures.article_fixture()
      update_attrs = %{title: "Updated Title"}

      assert {:ok, %Article{} = updated_article} = Content.update_article(article, update_attrs)
      assert updated_article.title == "Updated Title"
    end

    test "returns error changeset with invalid data" do
      article = ContentFixtures.article_fixture()
      invalid_attrs = %{title: nil}

      assert {:error, %Ecto.Changeset{}} = Content.update_article(article, invalid_attrs)
    end
  end

  describe "delete_article/1" do
    test "deletes the article" do
      article = ContentFixtures.article_fixture()

      assert {:ok, %{"result" => "deleted"}} = Content.delete_article(article)

      assert_raise Ecto.NoResultsError, fn ->
        Content.get_article!(article.id)
      end
    end
  end

  describe "change_article/1" do
    test "returns a changeset for an article" do
      article = ContentFixtures.article_fixture()
      assert %Ecto.Changeset{} = Content.change_article(article)
    end
  end
end
