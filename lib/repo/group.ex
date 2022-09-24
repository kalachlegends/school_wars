defmodule Group do
  use Ecto.Schema

  schema "groups" do

    field :name, :string
    field :data, :map
    field :manager_id, :integer
    field :user_ids, {:array, :integer}
    field :comment_ids, {:array, :integer}
    field :inserted_at, :utc_datetime
  end

  def changeset(group, params \\ %{}) do
    group
    |> Ecto.Changeset.cast(params, [
      :name,
      :data,
      :manager_id,
      :user_ids,
      :comment_ids
    ])
    |> Ecto.Changeset.validate_required([
      :name,
      :data,
      :manager_id,
      :user_ids,
      :comment_ids
    ])
  end
end
