defmodule Role do
  use Ecto.Schema

  schema "roles" do
    field :name, :string
    field :permissions, {:array, :string}
    field :inserted_at, :utc_datetime
  end
end
