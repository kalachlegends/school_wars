defmodule Answer do
  use Ecto.Schema

  schema "answers" do

    field :rating, :integer
    field :author_id, :integer
    field :data, :map
    field :comment_ids, {:array, :integer}
    field :inserted_at, :utc_datetime

  end

  def changeset(answer, params \\ %{}) do
    answer
    |> Ecto.Changeset.cast(params, [
      :rating,
      :author_id,
      :data,
      :comment_ids
    ])
    |> Ecto.Changeset.validate_required([
      :rating,
      :author_id,
      :data,
      :comment_ids
    ])
  end
end
