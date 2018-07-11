defmodule SmokeShop.Purchasers.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:email, :string)
    field(:first_name, :string)
    field(:street_name, :string)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :street_name, :first_name])
    |> validate_required([:email, :street_name, :first_name])
  end
end
