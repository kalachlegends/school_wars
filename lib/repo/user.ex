defmodule User do
  use Ecto.Schema

  schema "users" do
    field :login, :string
    field :hash, :string, redact: true
    field :data, :map
    field :comments, {:array, :integer}
    field :inserted_at, :utc_datetime
  end
end
