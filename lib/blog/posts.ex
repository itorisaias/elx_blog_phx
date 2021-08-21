defmodule Blog.Posts do
  @moduledoc """
  Posts module
  """

  alias Blog.{Posts.Post, Repo}

  def list_posts do
    Repo.all(Post)
  end

  def get_post!(id) do
    Repo.get!(Post, id)
  end

  def get_post_with_comments!(id) do
    Repo.get!(Post, id) |> Repo.preload(:comments)
  end

  def create_post(attrs \\ {}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  def update_post(id, attrs \\ {}) do
    Post
    |> Repo.get!(id)
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  def delete_post!(id) do
    Post
    |> Repo.get!(id)
    |> Repo.delete!()
  end
end
