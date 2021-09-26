defmodule Mango.CRMTest do
  use Mango.DataCase
  alias Mango.CRM
  alias Mango.CRM.Customer

  @valid_attrs %{
    "name" => "John",
    "email" => "John@email.com",
    "password" => "secret",
    "residence_area" => "Area 1",
    "phone" => "1111"
  }

  test "build_customer/0 returns a customer changeset" do
    assert %Ecto.Changeset{data: %Customer{}} = CRM.build_customer
  end

  test "build_customer/1 returns a customer changeset with values applied" do
    attrs = %{"name" => "John"}
    changeset = CRM.build_customer(attrs)
    assert changeset.params == attrs
  end

  test "create_customer/1 returns a customer for valid data" do
    assert {:ok, customer} = CRM.create_customer(@valid_attrs)
    assert Bcrypt.verify_pass(@valid_attrs["password"], customer.password_hash)
  end

  test "create_customer/1 returns a changeset for invalid data" do
    invalid_attrs = %{}
    assert {:error, %Ecto.Changeset{}} = CRM.create_customer(invalid_attrs)
  end

  test "get_customer_by_email/1 should return the given customer" do
    {:ok, customer_1} = CRM.create_customer(@valid_attrs)
    customer_2 = CRM.get_customer_by_email("john@email.com")
    assert customer_1.id == customer_2.id
  end

  test "get_customer_by_credentials/2 should return the given customer" do
    {:ok, customer_1} = CRM.create_customer(@valid_attrs)
    customer_2 = CRM.get_customer_by_credentials("john@email.com", "secret")
    assert customer_1.id == customer_2.id
  end

end
