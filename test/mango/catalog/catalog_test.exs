defmodule Mango.CatalogTest do
  use Mango.DataCase

  alias Mango.{Catalog, Repo}
  alias Mango.Catalog.Product

  setup do
    Repo.insert(%Product{name: "Tomato", price: 50, is_seasonal: false, category: "vegetables"})
    Repo.insert(%Product{name: "Apple", price: 100, is_seasonal: true, category: "fruits"})
    :ok
  end

  test "list_products/0 returns all products" do
    [p1 = %Product{}, p2 = %Product{}] = Catalog.list_products()

    assert p1.name == "Tomato"
    assert p2.name == "Apple"
  end

  test "list_seasonal_products/0 returns all seasonal products" do
    [product = %Product{}] = Catalog.list_seasonal_products()

    assert product.is_seasonal
    assert product.name == "Apple"
  end

  test "get_category_products/1 returns products from the given category" do
    [product = %Product{}] = Catalog.get_category_products("fruits")

    assert product.name == "Apple"
  end
end
