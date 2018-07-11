defmodule SmokeShopWeb.PageController do
  use SmokeShopWeb, :controller

  alias SmokeShop.Products

  def index(conn, _params) do
    products = Products.list_products()
    user_id = get_session(conn, :user_id)

    render(
      conn,
      "index.html",
      products: products,
      user: user(user_id)
    )
  end

  def logout(conn, _) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def user(nil), do: nil

  def user(user_id) do
    SmokeShop.Purchasers.get_user!(user_id)
  end
end
