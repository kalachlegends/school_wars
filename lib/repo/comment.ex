defmodule Comment do
  use Ecto.Schema

  schema "comments" do
    add :content, :string
    add :rating, :integer
    add :author, :integer
    add :inserted_at, :utc_datetime
  end
end
