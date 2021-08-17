# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Blog.Repo.insert!(%Blog.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Blog.{Repo, Posts.Post}

post1 = Post.changeset(%Post{}, %{title: "Post 1", description: "Description post 1"})
post2 = Post.changeset(%Post{}, %{title: "Post 2", description: "Description post 2"})

Repo.insert!(post1)
Repo.insert!(post2)
