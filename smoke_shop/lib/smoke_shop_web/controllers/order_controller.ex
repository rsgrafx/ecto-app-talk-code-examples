defmodule SmokeShopWeb.OrderController do
  use SmokeShopWeb, :controller

  alias SmokeShop.Orders
  alias SmokeShop.Orders.Order
  alias SmokeShop.Purchasers
  alias SmokeShop.Purchasers.User
  alias SmokeShop.Products

  def index(conn, _params) do
    orders = Orders.list_orders()
    render(conn, "index.html", orders: orders)
  end

  def new(conn, _params) do
    case get_session(conn, :user_id) do
      nil ->
        changeset = Purchasers.change_user(%User{})

        conn
        |> redirect(to: "/users/new")

      val when is_integer(val) ->
        user = Purchasers.get_user!(val)
        changeset = Orders.change_order(%Order{})
        cart = get_cart(conn)

        render(
          conn,
          "new.html",
          changeset: changeset,
          user: user,
          products: cart.items,
          counts: cart.counts,
          total: cart.total
        )
    end
  end

  defp get_cart(conn) do
    case get_session(conn, :cart_ids) do
      nil ->
        %{items: [], counts: 0}

      list when is_list(list) ->
        products = Products.product_list(list)
        Orders.build_details(products, list)
    end
  end

  defp quantities(list) do
    Orders.quantities(list)
  end

  def create(conn, %{"order" => order_params}) do
    cart = get_cart(conn)
    order_params = Map.merge(order_params, %{"cart" => cart})

    case Orders.create_order(order_params) do
      {:ok, order} ->
        conn
        |> put_flash(:info, "Order created successfully.")
        |> redirect(to: order_path(conn, :show, order))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    order = Orders.get_order!(id)
    render(conn, "show.html", order: order)
  end

  def edit(conn, %{"id" => id}) do
    order = Orders.get_order!(id)
    changeset = Orders.change_order(order)
    render(conn, "edit.html", order: order, changeset: changeset)
  end

  def update(conn, %{"id" => id, "order" => order_params}) do
    order = Orders.get_order!(id)

    case Orders.update_order(order, order_params) do
      {:ok, order} ->
        conn
        |> put_flash(:info, "Order updated successfully.")
        |> redirect(to: order_path(conn, :show, order))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", order: order, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    order = Orders.get_order!(id)
    {:ok, _order} = Orders.delete_order(order)

    conn
    |> put_flash(:info, "Order deleted successfully.")
    |> redirect(to: order_path(conn, :index))
  end
end
