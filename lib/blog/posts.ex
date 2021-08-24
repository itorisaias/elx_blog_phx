defmodule Blog.Posts do
  @moduledoc """
  Posts module
  """
  import Ecto.Query, warn: false
  alias Blog.{Posts.Post, Repo}

  def list_posts(user_id \\ nil) do
    if user_id do
      query = from p in Post, where: p.user_id == ^user_id
      Repo.all(query)
    else
      Repo.all(Post)
    end
  end

  def get_post!(id) do
    Repo.get!(Post, id)
  end

  def get_post_with_comments!(id) do
    Repo.get!(Post, id) |> Repo.preload(comments: [:user])
  end

  def create_post(user, attrs \\ {}) do
    user
    |> Ecto.build_assoc(:posts)
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
