defmodule Achievement do
  use Ecto.Schema

  schema "achievements" do
    field :content, :string
    field :count, :integer
    field :inserted_at, :utc_datetime
  end
end
