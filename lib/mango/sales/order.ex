defmodule Mango.Sales.Order do
  use Ecto.Schema
  import Ecto.Changeset
  alias Mango.Sales.LineItem

  schema "orders" do
    field :status, :string
    field :total, :decimal
    embeds_many :line_items, LineItem, on_replace: :delete
    field :comments, :string
    field :customer_id, :integer
    field :customer_name, :string
    field :email, :string
    field :residence_area, :string

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = order, attrs) do
    order
    |> cast(attrs, [:status, :total])
    |> cast_embed(:line_items, required: true, with: &LineItem.changeset/2)
    |> set_order_total
    |> validate_required([:status, :total])
  end

  def checkout_changeset(%__MODULE__{} = order, attrs) do
    required_attrs = [:customer_id, :customer_name, :residence_area, :email]

    changeset(order, attrs)
    |> cast(attrs, [:comments | required_attrs])
    |> validate_required(required_attrs)
  end

  defp set_order_total(changeset) do
    items = get_field(changeset, :line_items)

    total =
      Enum.reduce(items, Decimal.new(0), fn item, acc ->
        Decimal.add(acc, item.total)
      end)

    changeset
    |> put_change(:total, total)
  end
end
