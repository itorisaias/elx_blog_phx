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

defmodule SeedCustom do
  alias Blog.{Repo, Posts.Post, Accounts.User}

  defp fixture_post(user, post) do
    user
    |> Ecto.build_assoc(:posts)
    |> Post.changeset(post)
    |> Repo.insert!()
  end

  def init do
    user =
      Repo.insert!(
        User.changeset(%User{}, %{email: "itor isaias", provider: "local", token: "token-fake"})
      )

    post1 = %{title: "Post 1", description: "Description post 1", user_id: user.id}
    post2 = %{title: "Post 2", description: "Description post 2", user_id: user.id}

    fixture_post(user, post1)
    fixture_post(user, post2)
  end
end

# SeedCustom.init()
