defmodule Mango.CRM do
  alias Mango.CRM.Customer
  alias Mango.Repo
  import Bcrypt, only: [check_pass: 2]

  def build_customer(attrs \\ %{}) do
    %Customer{}
    |> Customer.changeset(attrs)
  end

  def create_customer(attrs) do
    attrs
    |> build_customer
    |> Repo.insert
  end

  def get_customer_by_email(email) do
    Repo.get_by(Customer, email: email)
  end

  def get_customer_by_credentials(email, password) do
    customer = get_customer_by_email(email)
    cond do
      customer && check_pass(password, customer.password_hash) ->
        customer
      true -> :error
    end
  end
end
