defmodule SchoolWars.Repo.Migrations.Answers do
  use Ecto.Migration

  def change do
    create table("answers") do
      add :author_id, references(:users)
      add :work_id, references(:works)
      add :data, :map
      add :ratings, :map
      add :comment_ids, {:array, :integer}
      add :inserted_at, :utc_datetime, default: fragment("now()")
    end
  end
end
