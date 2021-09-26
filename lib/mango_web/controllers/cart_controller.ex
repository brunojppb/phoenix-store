defmodule MangoWeb.CartController do
  use MangoWeb, :controller
  alias Mango.Sales

  def add(conn, %{"cart" => cart_params}) do
    cart = conn.assigns.cart
    case Sales.add_to_cart(cart, cart_params) do
      {:ok, _} ->
        # Do something
        %{"product_name" => name, "quantity" => quantity} = cart_params
        message = "Product added to cart - #{name} x #{quantity} quantity"
        conn
        |> put_flash(:info, message)
        |> redirect(to: Routes.page_path(conn, :index))
      {:error, _} ->
        conn
        |> put_flash(:info, "Error adding product to cart")
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end

end
