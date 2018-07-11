Repo.insert_all("orders", [[name: "Mags Purchase", purchaser_id: 1]])

# order_items: [
#   [
#     name: "Christmas Kush",
#     description: "Snowflake, flower, soothing, Aromatic",
#     price: 10.00,
#     quantity: 3
#   ]
# ]

Repo.insert_all("items", [
  [
    name: "Christmas Kush",
    description: "Snowflake, flower, soothing, Aromatic",
    price: 10.00,
    quantity: 3,
    order_id: 1
  ]
])
