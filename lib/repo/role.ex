defmodule Role do
  use Ecto.Schema

  schema "roles" do
    field :name, :string
    field :permissions, {:array, :string}
    field :inserted_at, :utc_datetime
  end

  def changeset(role, params \\ %{}) do
    role
    |> Ecto.Changeset.cast(params, [:name, :permissions])
    |> Ecto.Changeset.validate_required([:name, :permissions])
  end
end
