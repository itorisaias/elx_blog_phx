defmodule BlogWeb.CommentsChannel do
  @moduledoc """
  Comments channel
  """
  use BlogWeb, :channel

  def join("comments:" <> post_id, _payload, socket) do
    post = Blog.Posts.get_post_with_comments!(post_id)

    socket =
      socket
      |> assign(:post_id, post.id)

    {:ok, %{comments: post.comments}, socket}
  end

  def handle_in("comment:add", payload, socket) do
    post_id = socket.assigns.post_id

    response =
      post_id
      |> Blog.Comments.create_comment(payload)

    case response do
      {:ok, comment} ->
        broadcast(socket, "comments:#{post_id}:new", comment)
        {:reply, :ok, socket}

      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}}
    end
  end
end
