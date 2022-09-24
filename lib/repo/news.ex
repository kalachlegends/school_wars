defmodule News do
  use Ecto.Schema

  schema "news" do
    field :ratings, :map
    field :group_id, :integer
    field :rated_users, {:array, :integer}
    field :data, :map
    field :inserted_at, :utc_datetime
  end

  def changeset(comment, params \\ %{}) do
    comment
    |> Ecto.Changeset.cast(params, [:ratings, :group_id, :data, :rated_users])
    |> Ecto.Changeset.validate_required([:ratings, :group_id, :data, :rated_users])
    |> Ecto.Changeset.foreign_key_constraint(:group_id)
  end
end
