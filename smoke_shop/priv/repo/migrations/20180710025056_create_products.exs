defmodule SmokeShop.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :street_name, :string
      add :url, :string

      timestamps()
    end

  end
end
