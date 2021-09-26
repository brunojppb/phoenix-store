defmodule MangoWeb.OrderController do
  use MangoWeb, :controller
  alias Mango.Sales

  def index(conn, _params) do
    customer = conn.assigns.current_customer
    orders = Sales.get_customer_orders(customer.id)
    render(conn, "index.html", orders: orders)
  end

  def show(conn, %{"id" => order_id}) do
    customer = conn.assigns.current_customer
    case Sales.get_customer_order(order_id, customer.id) do
      nil ->
        conn
        |> put_flash(:info, "Order not found")
        |> redirect(to: Routes.order_path(conn, :index))
      order ->
        render(conn, "show.html", order: order)
    end
  end

end
