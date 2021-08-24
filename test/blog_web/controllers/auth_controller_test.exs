defmodule BlogWeb.AuthControllerTest do
  use BlogWeb.ConnCase

  @ueberauth_success %Ueberauth.Auth{
    credentials: %{
      token: "123"
    },
    info: %{
      email: "teste@teste",
      first_name: "Itor",
      last_name: "Isaias",
      image: "url_img"
    },
    provider: "google"
  }

  @ueberauth_error %Ueberauth.Auth{
    credentials: %{
      token: nil
    },
    info: %{
      email: "teste@teste",
      first_name: nil,
      last_name: nil,
      image: "url_img"
    },
    provider: "google"
  }

  defp fixture(:user) do
    {:ok, user} =
      Blog.Accounts.create_user(%{
        email: "itor isaias",
        provider: "local",
        token: "token-fake"
      })

    user
  end

  test "callback success", %{conn: conn} do
    conn =
      conn
      |> assign(:ueberauth_auth, @ueberauth_success)
      |> get(Routes.auth_path(conn, :callback, "google"))

    assert redirected_to(conn) == Routes.page_path(conn, :index)
    conn = get(conn, Routes.page_path(conn, :index))
    assert html_response(conn, 200) =~ "Bem vindo #{@ueberauth_success.info.email}!"
  end

  test "callback with error", %{conn: conn} do
    conn =
      conn
      |> assign(:ueberauth_auth, @ueberauth_error)
      |> get(Routes.auth_path(conn, :callback, "google"))

    assert redirected_to(conn) == Routes.page_path(conn, :index)
    conn = get(conn, Routes.page_path(conn, :index))
    assert html_response(conn, 200) =~ "Falha na autenticação!"
  end

  test "logout", %{conn: conn} do
    conn =
      conn
      |> Plug.Test.init_test_session(user_id: fixture(:user).id)
      |> get(Routes.auth_path(conn, :logout))

    assert redirected_to(conn) == Routes.page_path(conn, :index)
  end
end
