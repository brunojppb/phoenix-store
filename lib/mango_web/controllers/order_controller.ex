defmodule MangoWeb.OrderController do
  use MangoWeb, :controller
  alias Mango.Sales

  def index(conn, _params) do
    customer = conn.assigns.current_customer
    orders = Sales.get_customer_orders(customer.id)
    render(conn, "index.html", orders: orders)
  end

end
