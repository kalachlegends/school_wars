defmodule Achievement do
  use Ecto.Schema

  schema "achievements" do
    field :content, :string
    field :count, :integer
    field :inserted_at, :utc_datetime
  end

  def changeset(achievement, params \\ %{}) do
    achievement
    |> Ecto.Changeset.cast(params, [:content, :count])
    |> Ecto.Changeset.validate_required([:content, :count])
  end
end
