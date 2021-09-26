defmodule MangoWeb.SessionController do
  use MangoWeb, :controller
  alias Mango.CRM

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => session_params}) do
    %{"email" => email, "password" => password} = session_params
    case CRM.get_customer_by_credentials(email, password) do
      :error ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> render("new.html")
      customer ->
        conn
        |> assign(:current_customer, customer)
        |> put_session(:customer_id, customer.id)
        |> configure_session(renew: true)
        |> put_flash(:info, "Welcome back, #{customer.name}!")
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end
end
