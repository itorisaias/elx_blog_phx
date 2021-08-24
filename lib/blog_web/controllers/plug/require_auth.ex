defmodule BlogWeb.Plug.RequireAuth do
  @moduledoc """
  Plug required auth
  """
  use BlogWeb, :controller

  import Plug.Conn

  def init(_opts) do
  end

  def call(conn, _params) do
    if conn.assigns[:user] do
      conn
    else
      conn
      |> put_flash(:error, "Voce precisa estar logado!!")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
end
