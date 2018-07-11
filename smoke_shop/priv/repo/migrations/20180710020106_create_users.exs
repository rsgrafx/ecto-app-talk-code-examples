defmodule SmokeShop.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :street_name, :string
      add :first_name, :string

      timestamps()
    end

  end
end
