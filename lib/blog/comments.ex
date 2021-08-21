defmodule Blog.Comments do
  @moduledoc """
  The Comments context.
  """

  import Ecto.Query, warn: false
  alias Blog.Repo

  alias Blog.Comments.Comment

  def list_comments do
    Repo.all(Comment)
  end

  def get_comment!(id), do: Repo.get!(Comment, id)

  def create_comment(post_id, attrs \\ %{}) do
    Blog.Posts.get_post!(post_id)
    |> Ecto.build_assoc(:comments)
    |> change_comment(attrs)
    |> Repo.insert()
  end

  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end
end
