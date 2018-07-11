defmodule SmokeShop.Repo.Migrations.AddCurrentCartsView do
  use Ecto.Migration

  def change do
    execute(
      """
      create view current_carts (items, inserted_at, email, first_name) as
      select cart->>'items'
      as items, o.inserted_at, u.email, u.first_name
      from orders o
      join users u
      	on u.id = o.user_id
      order by o.inserted_at desc;
      """,
      "drop view current_carts;"
    )
  end
end
