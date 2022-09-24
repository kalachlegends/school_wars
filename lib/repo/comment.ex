defmodule Comment do
  use Ecto.Schema

  schema "comments" do
    field :content, :string
    field :rating, :integer
    field :author_id, :integer
    field :inserted_at, :utc_datetime
  end

  def changeset(comment, params \\ %{}) do
    comment
    |> Ecto.Changeset.cast(params, [:content, :rating, :author_id])
    |> Ecto.Changeset.validate_required([:content, :rating, :author_id])
  end
end
