defmodule Mango.CRM.Customer do
  use Ecto.Schema
  import Ecto.Changeset
  import Bcrypt, only: [add_hash: 1]
  alias Mango.CRM.Ticket

  schema "customers" do
    field :email, :string
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :phone, :string
    field :residence_area, :string
    has_many :tickets, Ticket

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = customer, attrs) do
    customer
    |> cast(attrs, [:name, :email, :phone, :residence_area, :password])
    |> validate_required([:name, :email, :residence_area, :password])
    |> validate_format(:email, ~r/@/, message: "is invalid")
    |> validate_length(:password, min: 6, max: 100)
    |> unique_constraint(:email)
    |> put_pw_hash()
  end

  defp put_pw_hash(changeset) do
    case changeset.valid? do
      true ->
        change(changeset, add_hash(changeset.changes.password))

      _ ->
        changeset
    end
  end
end
