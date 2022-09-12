defmodule Answer do
  use Ecto.Schema

  schema "answers" do
    field :content, :string
    field :rating, :integer
    field :author, :integer
    field :data, :map
    field :comments, {:array, :integer}
    field :inserted_at, :utc_datetime
  end

  def changeset(answer, params \\ %{}) do
    answer
    |> Ecto.Changeset.cast(params, [
      :content,
      :rating,
      :author,
      :data,
      :comments
    ])
    |> Ecto.Changeset.validate_required([
      :content,
      :rating,
      :author,
      :data,
      :comments
    ])
  end
end
