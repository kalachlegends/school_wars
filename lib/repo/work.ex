defmodule Work do
  use Ecto.Schema

  schema "works" do

    field :rating, :integer
    field :status, :string
    field :author, :integer
    field :data, :map
    field :answer_ids, {:array, :integer}
    field :comment_ids, {:array, :integer}
    field :inserted_at, :utc_datetime

  end

  def changeset(work, params \\ %{}) do
    work
    |> Ecto.Changeset.cast(params, [
      :rating,
      :status,
      :author,
      :data,
      :answer_ids,
      :comment_ids
    ])
    |> Ecto.Changeset.validate_required([
      :rating,
      :status,
      :author,
      :data,
      :answer_ids,
      :comment_ids
    ])
  end
end
