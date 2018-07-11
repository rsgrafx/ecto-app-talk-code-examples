defmodule SmokeShop.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add(:cart, :map)
      timestamps()
    end
  end
end
