defmodule SmokeShop.Repo.Migrations.CreateOrderChannelFunction do
  use Ecto.Migration

  def change do
    execute(
      """
      CREATE OR REPLACE FUNCTION fetch_cart_owner(numeric)
      RETURNS record AS $$
          select users.email, users.street_name from users
          join orders on orders.user_id = users.id
          where orders.user_id = $1;
      $$ LANGUAGE sql;
      """,
      "DROP FUNCTION fetch_cart_owner(numeric)"
    )
  end
end
