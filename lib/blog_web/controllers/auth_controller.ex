defmodule BlogWeb.AuthController do
  use BlogWeb, :controller

  plug Ueberauth

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, %{"provider" => provider}) do
    user = %{
      token: auth.credentials.token,
      email: auth.info.email,
      first_name: auth.info.first_name,
      last_name: auth.info.last_name,
      image: auth.info.image,
      provider: provider
    }

    IO.inspect(user)
    render(conn, "index.html")
  end
end
