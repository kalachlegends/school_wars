defmodule Comment do
  use Ecto.Schema

  schema "comments" do
    add :content, :string
    add :rating, :integer
    add :author, :integer
    add :inserted_at, :utc_datetime
  end

  def changeset(comment, params \\ %{}) do
    comment
    |> Ecto.Changeset.cast(params, [:content, :rating, :author])
    |> Ecto.Changeset.validate_required([:content, :rating, :author])
  end
end
