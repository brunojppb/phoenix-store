defmodule Mango.CRM do
  import Ecto.Query, warn: false
  alias Mango.CRM.Customer
  alias Mango.Repo
  alias Mango.CRM.Ticket
  import Bcrypt, only: [check_pass: 2]

  def build_customer(attrs \\ %{}) do
    %Customer{}
    |> Customer.changeset(attrs)
  end

  def create_customer(attrs) do
    attrs
    |> build_customer
    |> Repo.insert()
  end

  def get_customer_by_email(email) do
    Repo.get_by(Customer, email: email)
  end

  def get_customer_by_credentials(email, password) do
    customer = get_customer_by_email(email)

    cond do
      customer && check_pass(password, customer.password_hash) ->
        customer

      true ->
        :error
    end
  end

  def get_customer(id) do
    Repo.get(Customer, id)
  end

  def list_tickets do
    Repo.all(Ticket)
  end

  def build_customer_ticket(%Customer{} = customer, attrs \\ %{}) do
    Ecto.build_assoc(customer, :tickets, %{status: "New"})
    |> Ticket.changeset(attrs)
  end

  def create_customer_ticket(%Customer{} = customer, attrs \\ %{}) do
    build_customer_ticket(customer, attrs)
    |> Repo.insert()
  end

  def list_customer_tickets(customer) do
    customer
    |> Ecto.assoc(:tickets)
    |> Repo.all()
  end

  def get_customer_ticket!(customer, id) do
    customer
    |> Ecto.assoc(:tickets)
    |> Repo.get(id)
  end

  @doc """
  Gets a single ticket.

  Raises `Ecto.NoResultsError` if the Ticket does not exist.

  ## Examples

      iex> get_ticket!(123)
      %Ticket{}

      iex> get_ticket!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ticket!(id), do: Repo.get!(Ticket, id)

  @doc """
  Updates a ticket.

  ## Examples

      iex> update_ticket(ticket, %{field: new_value})
      {:ok, %Ticket{}}

      iex> update_ticket(ticket, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ticket(%Ticket{} = ticket, attrs) do
    ticket
    |> Ticket.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ticket.

  ## Examples

      iex> delete_ticket(ticket)
      {:ok, %Ticket{}}

      iex> delete_ticket(ticket)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ticket(%Ticket{} = ticket) do
    Repo.delete(ticket)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ticket changes.

  ## Examples

      iex> change_ticket(ticket)
      %Ecto.Changeset{data: %Ticket{}}

  """
  def change_ticket(%Ticket{} = ticket, attrs \\ %{}) do
    Ticket.changeset(ticket, attrs)
  end
end
