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

alias Blog.{Accounts, Posts}

user = %{
  email: "itor isaias",
  provider: "local",
  token: "token-fake"
}

post = %{title: "Post 1", description: "Description post 1"}

{:ok, user} = Accounts.create_user(user)

{:ok, _post} = Posts.create_post(user, post)
