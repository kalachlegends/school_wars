defmodule SchoolWars.Repo.Migrations.Comments do
  use Ecto.Migration

  def change do
    create table("comments") do
      add :data, :map
      add :ratings, :map
      add :author_id, references(:users)
      add :inserted_at, :utc_datetime, default: fragment("now()")
    end
  end
end
