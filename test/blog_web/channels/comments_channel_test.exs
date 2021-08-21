defmodule BlogWeb.CommentsChannelTest do
  @moduledoc """
  Test comments channel
  """
  use BlogWeb.ChannelCase

  alias Blog.Posts
  alias BlogWeb.UserSocket
  # alias BlogWeb.CommentsChannel

  @valid_post %{
    title: "Elixir izi",
    description: "Description post"
  }

  setup do
    {:ok, socket} = connect(UserSocket, %{})
    {:ok, post} = Posts.create_post(@valid_post)

    {:ok, socket: socket, post: post}
  end

  test "deve se conectar ao socket", %{socket: socket, post: post} do
    {:ok, payload, socket} = subscribe_and_join(socket, "comments:#{post.id}", %{})

    assert post.id == socket.assigns.post_id
    assert [] == payload.comments
  end

  test "deve emitir o evento sucesso quando criar novo comentario", %{socket: socket, post: post} do
    {:ok, _payload, socket} = subscribe_and_join(socket, "comments:#{post.id}", %{})

    ref = push(socket, "comment:add", %{"content" => "new post"})

    event_name = "comments:#{post.id}:new"
    msg = %{content: "new post"}

    assert_reply ref, :ok, %{}
    assert_broadcast event_name, msg
    refute is_nil(msg)
  end

  # test "deve emitir um evento de erro quando commentario não estiver valido", %{socket: socket, post: post} do
  #   {:ok, _payload, socket} = subscribe_and_join(socket, "comments:#{post.id}", %{})

  #   ref = push(socket, "comment:add", %{})

  #   # assert_reply ref, :error, %{}
  #   assert_reply ref, :error, %{errors: %{changes: %{}}}
  # end
end
