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
    user_id = socket.assigns.user_id

    response = Blog.Comments.create_comment(user_id, post_id, payload)

    case response do
      {:ok, comment} ->
        broadcast(socket, "comments:#{post_id}:new", comment |> Blog.Repo.preload(:user))
        {:reply, :ok, socket}

      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}}
    end
  end
end
