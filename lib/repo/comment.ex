defmodule Comment do
  use Ecto.Schema

  schema "comments" do
    field :data, :map
    field :ratings, :map
    field :author_id, :integer
    field :inserted_at, :utc_datetime
  end

  def changeset(comment, params \\ %{}) do
    comment
    |> Ecto.Changeset.cast(params, [:data, :ratings, :author_id])
    |> Ecto.Changeset.validate_required([:data, :ratings, :author_id])
    |> Ecto.Changeset.foreign_key_constraint(:author_id)
  end
end
