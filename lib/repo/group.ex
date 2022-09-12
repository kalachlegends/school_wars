defmodule Group do
  use Ecto.Schema

  schema "groups" do
    field :name, :string
    field :rating, :integer
    field :data, :map
    field :users, {:array, :integer}
    field :comments, {:array, :integer}
    field :inserted_at, :utc_datetime
  end

  def changeset(group, params \\ %{}) do
    group
    |> Ecto.Changeset.cast(params, [
      :name,
      :rating,
      :data,
      :users,
      :comments
    ])
    |> Ecto.Changeset.validate_required([
      :name,
      :rating,
      :data,
      :users,
      :comments
    ])
  end
end
