defmodule Mango.Catalog do
  alias Mango.Catalog.Product

  def list_products do
    [
      %Product{name: "Tomato", price: 50, is_seasonal: false, category: "vegetables"},
      %Product{name: "Apple", price: 100, is_seasonal: true, category: "fruits"},
    ]
  end

  def list_seasonal_products do
    list_products()
    |> Enum.filter(fn(p) -> p.is_seasonal end)
  end

  def get_category_products(category) do
    list_products()
    |> Enum.filter(fn(p) -> p.category == category end)
  end

end
