defmodule SmokeShop.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Poison.Encoder, only: [:name, :street_name, :cost]}

  schema "products" do
    field(:name, :string)
    field(:street_name, :string)
    field(:url, :string)
    field(:cost, :float)

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :street_name, :url])
    |> validate_required([:name, :street_name, :url])
  end
end
