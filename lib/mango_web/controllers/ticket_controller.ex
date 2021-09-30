defmodule MangoWeb.TicketController do
  use MangoWeb, :controller

  alias Mango.CRM

  def index(conn, _params) do
    customer = conn.assigns.current_customer
    tickets = CRM.list_customer_tickets(customer)
    render(conn, "index.html", tickets: tickets)
  end

  @spec new(Plug.Conn.t(), any) :: Plug.Conn.t()
  def new(conn, _params) do
    customer = conn.assigns.current_customer
    changeset = CRM.build_customer_ticket(customer)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"ticket" => ticket_params}) do
    customer = conn.assigns.current_customer

    case CRM.create_customer_ticket(customer, ticket_params) do
      {:ok, ticket} ->
        conn
        |> put_flash(:info, "Ticket created successfully.")
        |> redirect(to: Routes.ticket_path(conn, :show, ticket.id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    customer = conn.assigns.current_customer
    case CRM.get_customer_ticket!(customer, id) do
      nil ->
        conn
        |> put_flash(:info, "Ticket not found")
        |> redirect(to: Routes.ticket_path(conn, :index))
      ticket ->
        render(conn, "show.html", ticket: ticket)
    end
  end
end
