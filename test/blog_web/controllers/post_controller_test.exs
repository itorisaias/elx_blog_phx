defmodule BlogWeb.PostControllerTest do
  use BlogWeb.ConnCase
  alias Blog.Posts

  @valid_post %{title: "Post 1", description: "posts 1"}
  @updated_post %{title: "Post 1 - new", description: "posts 1"}

  defp fixture(:post) do
    {:ok, post} = Posts.create_post(@valid_post)
    post
  end

  test "listar todos os post - GET /", %{conn: conn} do
    Posts.create_post(@valid_post)
    conn = get(conn, Routes.post_path(conn, :index))
    assert html_response(conn, 200) =~ "Post 1"
  end

  test "detalhe de um post - GET /posts/:id", %{conn: conn} do
    {:ok, post} = Posts.create_post(@valid_post)
    conn = get(conn, Routes.post_path(conn, :show, post))
    assert html_response(conn, 200) =~ "Post 1"
  end

  test "entrar no formulario de um novo post - GET /posts/new", %{conn: conn} do
    conn = get(conn, Routes.post_path(conn, :new))
    assert html_response(conn, 200) =~ "Criar Post"
  end

  test "criar um novo post - POST /posts", %{conn: conn} do
    conn = post(conn, Routes.post_path(conn, :create), post: @valid_post)

    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == Routes.post_path(conn, :show, id)

    conn = get(conn, Routes.post_path(conn, :show, id))
    assert html_response(conn, 200) =~ "Post 1"
  end

  test "criar um novo post com valores invalidos - POST /posts", %{conn: conn} do
    conn = post(conn, Routes.post_path(conn, :create), post: %{})

    assert html_response(conn, 200) =~ "can&#39;t be blank"
  end

  describe "depende de um post" do
    setup [:criar_post]

    test "entrar no formulario de edit post - GET /posts/:id/edit", %{conn: conn, post: post} do
      conn = get(conn, Routes.post_path(conn, :edit, post))
      assert html_response(conn, 200) =~ "Post 1"
      assert html_response(conn, 200) =~ "Editar Post"
    end

    test "atualizar um novo post - PUT /posts/:id", %{conn: conn, post: post} do
      conn = put(conn, Routes.post_path(conn, :update, post), post: @updated_post)

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
        put(conn, Routes.post_path(conn, :update, post), post: %{title: nil, description: nil})

      assert html_response(conn, 200) =~ "can&#39;t be blank"
    end

    test "deletar um post - DELTE /posts/:id", %{conn: conn, post: post} do
      conn = delete(conn, Routes.post_path(conn, :delete, post))

      assert redirected_to(conn) == Routes.post_path(conn, :index)

      assert_error_sent 404, fn -> get(conn, Routes.post_path(conn, :show, post)) end
    end
  end

  defp criar_post(_) do
    %{post: fixture(:post)}
  end
end
