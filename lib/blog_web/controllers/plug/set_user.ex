defmodule BlogWeb.Plug.SetUser do
  @moduledoc """
  Plug set user
  """
  import Plug.Conn
  alias Blog.Accounts

  def init(_opts) do
  end

  def call(conn, _params) do
    user_id = get_session(conn, :user_id)

    cond do
      user = user_id && Accounts.get_user!(user_id) ->
        assign(conn, :user, user)

      true ->
        assign(conn, :user, nil)
    end
  end
end
