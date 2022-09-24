defmodule User do
  use Ecto.Schema

  schema "users" do

    field :login, :string
    field :hash, :binary
    field :data, :map
    field :rating, :integer
    field :roles, {:array, :string}
    field :comment_ids, {:array, :integer}
    field :inserted_at, :utc_datetime

  end

  def changeset(user, params \\ %{}) do
    user
    |> Ecto.Changeset.cast(params, [:login, :hash, :data, :rating, :roles, :comment_ids])
    |> Ecto.Changeset.validate_required([:login, :hash, :data, :rating, :roles, :comment_ids])
    |> Ecto.Changeset.unique_constraint(:login)
  end
end
