defmodule MangoWeb.CartView do
  use MangoWeb, :view
  alias Mango.Sales.Order

  def cart_count(conn = %Plug.Conn{}) do
    cart_count(conn.assigns.cart)
  end

  def cart_count(cart = %Order{}) do
    Enum.reduce(cart.line_items, 0, fn item, acc ->
      acc + item.quantity
    end)
  end

  def render("add.json", %{cart: cart, cart_params: cart_params}) do
    %{"product_name" => name, "quantity" => quantity} = cart_params

    %{
      message: "Product added to cart - #{name} x #{quantity}",
      cart_count: cart_count(cart)
    }
  end
end
