defmodule Work do
  use Ecto.Schema

  schema "works" do
    field :status, :string
    field :author_id, :integer
    field :data, :map
    field :ratings, :map
    field :original, :binary
    field :front, :binary
    field :answer_ids, {:array, :integer}
    field :comment_ids, {:array, :integer}
    field :inserted_at, :utc_datetime
  end

  def changeset(work, params \\ %{}) do
    work
    |> Ecto.Changeset.cast(params, [
      :status,
      :author_id,
      :data,
      :original,
      :front,
      :ratings,
      :answer_ids,
      :comment_ids
    ])
    |> Ecto.Changeset.validate_required([
      :status,
      :author_id,
      :data,
      :original,
      :front,
      :ratings,
      :answer_ids,
      :comment_ids
    ])
    |> Ecto.Changeset.foreign_key_constraint(:author_id)
  end
end
