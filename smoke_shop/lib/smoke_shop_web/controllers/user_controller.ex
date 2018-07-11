defmodule SmokeShopWeb.UserController do
  use SmokeShopWeb, :controller

  alias SmokeShop.Purchasers
  alias SmokeShop.Purchasers.User

  def index(conn, _params) do
    users = Purchasers.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Purchasers.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Purchasers.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> put_session(:user_id, user.id)
        |> redirect(to: user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Purchasers.get_user!(id)

    conn
    |> put_session(:user_id, user.id)
    |> render("show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Purchasers.get_user!(id)
    changeset = Purchasers.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Purchasers.get_user!(id)

    case Purchasers.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Purchasers.get_user!(id)
    {:ok, _user} = Purchasers.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end
end
