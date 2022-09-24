defmodule SchoolWars.Repo.Migrations.News do
  use Ecto.Migration

  def change do
    create table("news") do
      add :data, :map
      add :ratings, :map
      add :rated_users, {:array, :integer}
      add :group_id, references(:groups), default: nil
      add :inserted_at, :utc_datetime, default: fragment("now()")
    end
  end
end
