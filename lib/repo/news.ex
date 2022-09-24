defmodule News do
  use Ecto.Schema

  schema "comments" do
    field :content, :string
    field :rating, :integer
    field :group_id, :integer
    field :inserted_at, :utc_datetime
  end

  def changeset(comment, params \\ %{}) do
    comment
    |> Ecto.Changeset.cast(params, [:content, :rating, :group_id])
    |> Ecto.Changeset.validate_required([:content, :rating, :group_id])
  end
end