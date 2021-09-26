defmodule Mango.Sales.LineItem do
  import Ecto.Changeset
  use Ecto.Schema
  alias Mango.Catalog

  embedded_schema do
    field :product_id, :integer
    field :product_name, :string
    field :pack_size, :string
    field :quantity, :integer
    field :unit_price, :decimal
    field :total, :decimal
  end

  @doc false
  def changeset(%__MODULE__{} = line_item, attrs) do
    required_attrs = [:product_id, :product_name, :pack_size, :quantity, :unit_price]
    line_item
    |> cast(attrs, [:total | required_attrs])
    |> set_product_details
    |> set_total
    |> validate_required(required_attrs)
  end

  defp set_product_details(changeset) do
    case get_change(changeset, :product_id) do
      nil ->
        changeset
      product_id ->
        product = Catalog.get_product!(product_id)
        changeset
        |> put_change(:product_name, product.name)
        |> put_change(:unit_price, product.price)
        |> put_change(:pack_size, product.pack_size)
    end
  end

  defp set_total(changeset) do
    quantity = get_field(changeset, :quantity) |> Decimal.new
    unit_price = get_field(changeset, :unit_price)
    changeset
    |> put_change(:total, Decimal.mult(unit_price, quantity))
  end
end
