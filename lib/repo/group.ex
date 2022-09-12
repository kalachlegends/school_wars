defmodule Group do
  use Ecto.Schema

  schema "groups" do
    field :name, :string
    field :rating, :integer
    field :data, :map
    field :users, {:array, :integer}
    field :comments, {:array, :integer}
    field :inserted_at, :utc_datetime
  end
end
