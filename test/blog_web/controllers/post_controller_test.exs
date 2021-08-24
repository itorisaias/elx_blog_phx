defmodule BlogWeb.PostControllerTest do
  use BlogWeb.ConnCase
  alias Blog.{Accounts, Posts}

  @valid_post %{title: "Post 1", description: "posts 1"}
  @updated_post %{title: "Post 1 - new", description: "posts 1"}

  defp fixture(:user) do
    {:ok, user} =
      Accounts.create_user(%{
        email: "itor isaias",
        provider: "local",
        token: "token-fake"
      })

    user
  end

  defp fixture(:post) do
    user = fixture(:user)

    {:ok, post} = Posts.create_post(user, @valid_post)
    post
  end

  test "listar todos os post - GET /", %{conn: conn} do
    post = fixture(:post)

    conn =
      conn
      |> Plug.Test.init_test_session(user_id: post.user_id)
      |> get(Routes.post_path(conn, :index))

    assert html_response(conn, 200) =~ "Post 1"
  end

  test "detalhe de um post - GET /posts/:id", %{conn: conn} do
    post = fixture(:post)
    conn = get(conn, Routes.post_path(conn, :show, post))
    assert html_response(conn, 200) =~ "Post 1"
  end

  test "entrar no formulario de um novo post - GET /posts/new", %{conn: conn} do
    conn =
      conn
      |> Plug.Test.init_test_session(user_id: fixture(:user).id)
      |> get(Routes.post_path(conn, :new))

    assert html_response(conn, 200) =~ "Criar Post"
  end

  test "entrar no formulario de um novo post sem usuario autenticado - GET /posts/new", %{
    conn: conn
  } do
    conn =
      conn
      |> get(Routes.post_path(conn, :new))

    assert redirected_to(conn) == Routes.page_path(conn, :index)
    conn = get(conn, Routes.page_path(conn, :index))
    assert html_response(conn, 200) =~ "Voce precisa estar logado!!"
  end

  test "criar um novo post - POST /posts", %{conn: conn} do
    conn =
      conn
      |> Plug.Test.init_test_session(user_id: fixture(:user).id)
      |> post(Routes.post_path(conn, :create), post: @valid_post)

    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == Routes.post_path(conn, :show, id)

    conn = get(conn, Routes.post_path(conn, :show, id))
    assert html_response(conn, 200) =~ "Post 1"
  end

  test "criar um novo post com valores invalidos - POST /posts", %{conn: conn} do
    conn =
      conn
      |> Plug.Test.init_test_session(user_id: fixture(:user).id)
      |> post(Routes.post_path(conn, :create), post: %{})

    assert html_response(conn, 200) =~ "can&#39;t be blank"
  end

  describe "depende de um post" do
    setup [:criar_post]

    test "entrar no formulario de edit post - GET /posts/:id/edit", %{conn: conn, post: post} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: fixture(:user).id)
        |> get(Routes.post_path(conn, :edit, post))

      assert html_response(conn, 200) =~ "Post 1"
      assert html_response(conn, 200) =~ "Editar Post"
    end

    test "entrar no formulario de edit post com outro dono e tentar alterar post", %{
      conn: conn,
      post: post
    } do
      {:ok, user_1} =
        Accounts.create_user(%{
          email: "user_1",
          provider: "local",
          token: "token-fake"
        })

      {:ok, user_2} =
        Accounts.create_user(%{
          email: "user_2",
          provider: "local",
          token: "token-fake"
        })

      {:ok, post} = Posts.create_post(user_1, @valid_post)

      conn =
        conn
        |> Plug.Test.init_test_session(user_id: user_2.id)
        |> get(Routes.post_path(conn, :edit, post))

      assert redirected_to(conn) == Routes.page_path(conn, :index)
      conn = get(conn, Routes.page_path(conn, :index))
      assert html_response(conn, 200) =~ "Voce não tem permissão para esta operação"
    end

    test "atualizar um novo post - PUT /posts/:id", %{conn: conn, post: post} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: fixture(:user).id)
        |> put(Routes.post_path(conn, :update, post), post: @updated_post)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.post_path(conn, :show, id)

      conn = get(conn, Routes.post_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Post 1 - new"
    end

    test "atualizar um novo post com valores invalidos - PUT /posts/:id", %{
      conn: conn,
      post: post
    } do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: fixture(:user).id)
        |> put(Routes.post_path(conn, :update, post), post: %{title: nil, description: nil})

      assert html_response(conn, 200) =~ "can&#39;t be blank"
    end

    test "deletar um post - DELTE /posts/:id", %{conn: conn, post: post} do
      conn =
        conn
        |> Plug.Test.init_test_session(user_id: fixture(:user).id)
        |> delete(Routes.post_path(conn, :delete, post))

      assert redirected_to(conn) == Routes.post_path(conn, :index)

      assert_error_sent(404, fn -> get(conn, Routes.post_path(conn, :show, post)) end)
    end
  end

  defp criar_post(_) do
    %{post: fixture(:post)}
  end
end
