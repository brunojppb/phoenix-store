defmodule MangoWeb.Plugs.AuthenticateUser do
  import Plug.Conn
  import Phoenix.Controller, only: [redirect: 2, put_flash: 3]
  alias MangoWeb.Router.Helpers, as: Routes

  def init(_opts), do: nil

  def call(conn, _) do
    case conn.assigns[:current_customer] do
      nil ->
        conn
        |> put_session(:intent_to_visit, conn.request_path)
        |> put_flash(:info, "You must be logged in")
        |> redirect(to: Routes.session_path(conn, :new))
        |> halt

      customer ->
        IO.puts("CURRENT CUSTOMER: #{inspect(customer)}")
        conn
    end
  end
end
