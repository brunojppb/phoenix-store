defmodule MangoWeb.Plugs.LoadCustomerTest do
  use MangoWeb.ConnCase
  alias Mango.CRM

  @valid_attrs %{
    "name" => "John",
    "email" => "John@email.com",
    "password" => "secret",
    "residence_area" => "Area 1",
    "phone" => "1111"
  }

  test "fetch customer from session on subsequent visit" do
    # make sure we have a customer in the DB
    {:ok, customer} = CRM.create_customer(@valid_attrs)

    # build a conn struct by posting to the login endpoint
    conn = post build_conn(), "/login", %{"session" => @valid_attrs}

    conn = get conn, "/"

    assert customer.id == conn.assigns.current_customer.id
  end

end
