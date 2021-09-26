defmodule Mango.SalesTest do
  use Mango.DataCase

  alias Mango.{Sales, Repo}
  alias Mango.Sales.Order
  alias Mango.Catalog.Product
  alias Mango.CRM

  @product_attrs %Product{
    name: "Tomato",
    pack_size: "1kg",
    price: 55,
    sku: "A123",
    is_seasonal: false,
    category: "vegetables"
  }

  @customer_attrs %{
    "name" => "John",
    "email" => "John@email.com",
    "password" => "secret",
    "residence_area" => "Area 1",
    "phone" => "1111"
  }

  test "create_cart" do
    assert %Order{status: "In Cart"} = Sales.create_cart
  end

  test "get_cart/1" do
    cart1 = Sales.create_cart
    cart2 = Sales.get_cart(cart1.id)
    assert cart1.id == cart2.id
  end

  test "add_to_cart/2" do
    p = Repo.insert!(@product_attrs)

    cart = Sales.create_cart()
    {:ok, cart} = Sales.add_to_cart(cart, %{"product_id" => p.id, "quantity" => 2})
    assert [line_item] = cart.line_items
    assert line_item.product_id == p.id
    assert line_item.product_name == "Tomato"
    assert line_item.quantity == 2
    assert line_item.unit_price == Decimal.new(p.price)
    assert line_item.total == Decimal.mult(Decimal.new(p.price), Decimal.new(2))
  end

  test "get_customer_orders/1 should return the orders for the given customer" do
    product = Repo.insert!(@product_attrs)
    {:ok, customer} = CRM.create_customer(@customer_attrs)

    customer_attrs = %{
      "customer_id" => customer.id,
      "customer_name" => customer.name,
      "email" => customer.email,
      "residence_area" => customer.residence_area
    }

    Enum.each(0..1, fn _v ->
      cart = Sales.create_cart()
      {:ok, order} = Sales.add_to_cart(cart, %{"product_id" => product.id, "quantity" => 10})

      {:ok, confirmedOrder} = Sales.confirm_order(order, customer_attrs)
      assert confirmedOrder.status == "Confirmed"
    end)

    orders = Sales.get_customer_orders(customer.id)
    assert length(orders) == 2
  end

end
