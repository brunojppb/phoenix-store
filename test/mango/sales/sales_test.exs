defmodule Mango.SalesTest do
  use Mango.DataCase

  alias Mango.{Sales, Repo}
  alias Mango.Sales.Order
  alias Mango.Catalog.Product
  require Logger

  test "create_cart" do
    assert %Order{status: "In Cart"} = Sales.create_cart
  end

  test "get_cart/1" do
    cart1 = Sales.create_cart
    cart2 = Sales.get_cart(cart1.id)
    assert cart1.id == cart2.id
  end

  test "add_to_cart/2" do
    p = %Product{
      name: "Tomato",
      pack_size: "1kg",
      price: 55,
      sku: "A123",
      is_seasonal: false,
      category: "vegetables"
    }
    p = Repo.insert!(p)

    cart = Sales.create_cart()
    {:ok, cart} = Sales.add_to_cart(cart, %{"product_id" => p.id, "quantity" => 2})
    assert [line_item] = cart.line_items
    assert line_item.product_id == p.id
    assert line_item.product_name == "Tomato"
    assert line_item.quantity == 2
    assert line_item.unit_price == Decimal.new(p.price)
    assert line_item.total == Decimal.mult(Decimal.new(p.price), Decimal.new(2))
  end

end
