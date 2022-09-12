defmodule User do
  use Ecto.Schema

  schema "users" do
    field :login, :string
    field :hash, :string, redact: true
    field :data, :map
    field :comments, {:array, :integer}
    field :inserted_at, :utc_datetime
  end

  def changeset(user, params \\ %{}) do
    user
    |> Ecto.Changeset.cast(params, [:login, :hash, :data, :comments])
    |> Ecto.Changeset.validate_required([:login, :hash, :data, :comments])
    |> Ecto.Changeset.unique_constraint(:login)
  end
end
