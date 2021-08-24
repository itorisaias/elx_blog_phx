defmodule Blog.Posts.Post do
  @moduledoc """
  Schema Post
  """
  use Ecto.Schema
  import Ecto.Changeset

  @required_field ~w[title description]a

  schema "posts" do
    field :title, :string
    field :description, :string

    has_many :comments, Blog.Comments.Comment

    belongs_to :user, Blog.Accounts.User

    timestamps()
  end

  def changeset(post, attrs \\ %{}) do
    post
    |> cast(attrs, @required_field)
    |> validate_required(@required_field)
  end
end
