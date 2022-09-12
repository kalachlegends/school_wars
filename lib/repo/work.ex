defmodule Work do
  use Ecto.Schema

  schema "works" do
    field :content, :string
    field :rating, :integer
    field :status, :integer
    field :author, :integer
    field :data, :map
    field :answers, {:array, :integer}
    field :comments, {:array, :integer}
    field :inserted_at, :utc_datetime
  end
end