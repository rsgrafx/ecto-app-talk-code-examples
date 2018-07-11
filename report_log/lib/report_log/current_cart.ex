defmodule ReportLog.CurrentCart do
  use Ecto.Schema

  @primary_key false
  schema "current_carts" do
    field(:items)
    field(:email)
    field(:first_name)
    timestamps(updated_at: false)
  end
end
