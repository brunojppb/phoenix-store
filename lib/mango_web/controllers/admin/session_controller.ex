defmodule MangoWeb.Admin.SessionController do
  use MangoWeb, :controller
  plug :set_layout

  alias Mango.Administration

  def new(conn, _params) do
    conn
    |> render("new.html")
  end

  def send_link(conn, %{"session" => %{"email" => email}}) do
    case Administration.get_admin_by_email(email) do
      nil ->
        conn
        |> put_flash(:error, "Auth error!")
        |> render("new.html")
      user ->
        link = generate_login_link(conn, user)
        conn
        |> put_flash(:info, "Your magic login link is #{link}")
        |> render("new.html")
    end
  end

  def create(conn, %{"token" => token}) do
    case verify_token(token) do
      {:ok, user_id} ->
        user = Administration.get_user!(user_id)
        conn
        |> assign(:current_admin, user)
        |> put_session(:admin_id, user.id)
        |> configure_session(renew: true)
        |> put_flash(:info, "Login success!")
        |> redirect(to: Routes.admin_user_path(conn, :index))
      {:error, _} ->
        conn
        |> put_flash(:error, "Authentication error")
        |> render(:new)
    end
  end

  def delete(conn, _) do
    clear_session(conn)
    |> put_flash(:info, "Logout successfuly completed")
    |> redirect(to: Routes.admin_session_path(conn, :new))
  end

  defp generate_login_link(conn, user) do
    token = Phoenix.Token.sign(MangoWeb.Endpoint, "user", user.id)
    Routes.admin_session_url(conn, :create, %{token: token})
  end

  defp set_layout(conn, _) do
    conn
    |> put_layout("admin_login.html")
  end

  @max_age 600 # 600 seconds | 10 minutes
  defp verify_token(token) do
    Phoenix.Token.verify(MangoWeb.Endpoint, "user", token, max_age: @max_age)
  end
end
