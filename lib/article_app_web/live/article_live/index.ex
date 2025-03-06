defmodule ArticleAppWeb.ArticleLive.Index do
  use ArticleAppWeb, :live_view

  alias ArticleApp.Content
  alias ArticleApp.Content.Article

  @impl true
  def mount(_params, _session, socket) do
    socket = stream(socket, :articles, Content.list_articles())
    socket = assign(socket, articles: [], search_author: "", search_tag: "", search_content: "")

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Article")
    |> assign(:article, Content.get_article!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Article")
    |> assign(:article, %Article{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Articles")
    |> assign(:article, nil)
  end

  @impl true
  def handle_info({ArticleAppWeb.ArticleLive.FormComponent, {:saved, article}}, socket) do
    {:noreply, stream_insert(socket, :articles, article)}
  end

  @impl true
  def handle_event(
        "search_articles",
        %{"author" => author, "tag" => tag, "content" => content},
        socket
      ) do
    socket = stream(socket, :articles, Content.search_articles(author, tag, content), reset: true)

    socket =
      assign(socket,
        search_author: author,
        search_tag: tag,
        search_content: content
      )

    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    article = Content.get_article!(id)
    {:ok, _} = Content.delete_article(article)

    {:noreply, stream_delete(socket, :articles, article)}
  end

  defp format_datetime(nil), do: "N/A"

  defp format_datetime(%NaiveDateTime{} = dt) do
    Timex.format!(dt, "{YYYY}-{0M}-{0D} {h24}:{m}:{s}")
  end

  defp format_datetime(%DateTime{} = dt) do
    dt
    |> DateTime.shift_zone!("Etc/UTC")
    |> Timex.format!("{YYYY}-{0M}-{0D} {h24}:{m}:{s}")
  end

  defp format_datetime(string) when is_binary(string) do
    case DateTime.from_iso8601(string) do
      {:ok, dt, _offset} -> format_datetime(dt)
      _ -> string
    end
  end

  defp format_tags(nil), do: " "

  defp format_tags(tags) when is_list(tags) do
    tags
    |> Enum.join(", ")
  end

  defp format_tags(tag), do: to_string(tag)
end
