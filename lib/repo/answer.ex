defmodule Answer do
  use Ecto.Schema

  schema "answers" do
    field :author_id, :integer
    field :work_id, :integer
    field :data, :map
    field :ratings, :map
    field :comment_ids, {:array, :integer}
    field :inserted_at, :utc_datetime
  end

  def changeset(answer, params \\ %{}) do
    answer
    |> Ecto.Changeset.cast(params, [
      :author_id,
      :work_id,
      :data,
      :ratings,
      :comment_ids
    ])
    |> Ecto.Changeset.validate_required([
      :author_id,
      :work_id,
      :data,
      :ratings,
      :comment_ids
    ])
  end
end
