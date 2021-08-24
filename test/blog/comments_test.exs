defmodule Blog.CommentsTest do
  @moduledoc """
  Comments test
  """
  use Blog.DataCase

  alias Blog.Comments

  describe "comments" do
    alias Blog.{Accounts, Comments.Comment, Posts}

    @valid_attrs %{content: "some content"}
    @update_attrs %{content: "some updated content"}
    @invalid_attrs %{content: nil}
    @user_valid %{
      email: "some email",
      first_name: "some first_name",
      image: "some image",
      last_name: "some last_name",
      provider: "some provider",
      token: "some token"
    }
    @valid_post %{
      title: "Post 1",
      description: "Description 1"
    }

    defp fixture(:user) do
      {:ok, user} = Accounts.create_user(@user_valid)

      user
    end

    defp fixture(:post) do
      user = fixture(:user)

      {:ok, post} = Posts.create_post(user, @valid_post)

      post
    end

    defp fixture(:comment) do
      post = fixture(:post)

      {:ok, comment} = Comments.create_comment(post.user_id, post.id, @valid_attrs)

      comment
    end

    test "list_comments/0 returns all comments" do
      comment = fixture(:comment)
      assert Comments.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = fixture(:comment)
      assert Comments.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      post = fixture(:post)

      assert {:ok, %Comment{} = comment} =
               Comments.create_comment(post.user_id, post.id, @valid_attrs)

      assert comment.content == "some content"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      post = fixture(:post)

      assert {:error, %Ecto.Changeset{}} =
               Comments.create_comment(post.user_id, post.id, @invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = fixture(:comment)
      assert {:ok, %Comment{} = comment} = Comments.update_comment(comment, @update_attrs)
      assert comment.content == "some updated content"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = fixture(:comment)
      assert {:error, %Ecto.Changeset{}} = Comments.update_comment(comment, @invalid_attrs)
      assert comment == Comments.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = fixture(:comment)
      assert {:ok, %Comment{}} = Comments.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Comments.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = fixture(:comment)
      assert %Ecto.Changeset{} = Comments.change_comment(comment)
    end
  end
end
