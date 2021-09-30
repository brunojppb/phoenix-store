defmodule MangoWeb.CheckoutController do
  use MangoWeb, :controller
  alias Mango.Sales

  def edit(conn, _params) do
    order = conn.assigns.cart
    order_changeset = Sales.change_cart(order)
    render(conn, "edit.html", order: order, order_changeset: order_changeset)
  end

  def update(conn, params) do
    order = conn.assigns.cart
    order_params = assoc_user_from_session(conn, params)

    case Sales.confirm_order(order, order_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Your order has been confirmed")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, order_changeset} ->
        render(conn, "edit.html", order: order, order_changeset: order_changeset)
    end

    render(conn, "edit.html")
  end

  def assoc_user_from_session(conn, params) do
    customer = conn.assigns.current_customer

    params
    |> Map.put("customer_id", customer.id)
    |> Map.put("customer_name", customer.name)
    |> Map.put("residence_area", customer.residence_area)
    |> Map.put("email", customer.email)
  end
end
