defmodule MangoWeb.Plugs.RequireAdminAuth do
  import Plug.Conn
  import Phoenix.Controller, only: [redirect: 2, put_flash: 3]
  alias MangoWeb.Router.Helpers, as: Routes

  def init(_opts), do: nil

  def call(conn, _) do
    case conn.assigns[:current_admin] do
      # User is not logged in
      # redirect them to login
      nil ->
        conn
        |> put_flash(:info, "You must be logged in to access the admin page")
        |> redirect(to: Routes.admin_session_path(conn, :new))
        |> halt

      # User is already logged in.
      # Let them through
      admin ->
        IO.puts("CURRENT Admin: #{inspect(admin.email)}")
        conn
    end
  end
end
