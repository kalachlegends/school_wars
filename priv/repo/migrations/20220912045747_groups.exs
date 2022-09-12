defmodule SchoolWars.Repo.Migrations.Groups do
  use Ecto.Migration

  def change do
    create table("groups") do
      add :name, :string
      add :rating, :integer
      add :data, :map
      add :users, {:array, :integer}
      add :comments, {:array, :integer}
      add :inserted_at, :utc_datetime, default: fragment("now()")
    end

  end
end
