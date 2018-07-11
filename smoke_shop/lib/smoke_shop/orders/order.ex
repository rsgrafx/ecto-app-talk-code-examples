defmodule SmokeShop.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias SmokeShop.Purchasers.User

  schema "orders" do
    field(:cart, :map)
    belongs_to(:user, User)
    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:cart, :user_id])
    |> validate_required([:cart, :user_id])
  end
end
