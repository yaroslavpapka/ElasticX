defmodule ArticleAppWeb.ArticleLive.FormComponent do
  use ArticleAppWeb, :live_component

  alias ArticleApp.Content

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage article records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="article-form"
        phx-target={@myself}
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:content]} type="text" label="Content" />
        <.input field={@form[:author_name]} type="text" label="Author name" />
        <.input field={@form[:published]} type="checkbox" label="Published" />
        <.input
          field={@form[:tags_string]}
          type="text"
          label="Tags"
          placeholder="Enter tags"
        />
        <.input field={@form[:label]} type="text" label="Label" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Article</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{article: article} = assigns, socket) do
    article =
      if Map.has_key?(article, :tags) and is_list(article.tags) do
        Map.put(article, :tags_string, Enum.join(article.tags, ", "))
      else
        article
      end

    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Content.change_article(article))
     end)}
  end

  @impl true
  def handle_event("validate", %{"article" => article_params}, socket) do
    changeset = Content.change_article(socket.assigns.article, article_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"article" => article_params}, socket) do
    save_article(socket, socket.assigns.action, article_params)
  end

  defp save_article(socket, :edit, article_params) do
    case Content.update_article(socket.assigns.article, article_params) do
      {:ok, article} ->
        notify_parent({:saved, article})

        {:noreply,
         socket
         |> put_flash(:info, "Article updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_article(socket, :new, article_params) do
    case Content.create_article(article_params) do
      {:ok, article} ->
        notify_parent({:saved, article})

        {:noreply,
         socket
         |> put_flash(:info, "Article created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
