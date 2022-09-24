defmodule SchoolWars.Repo.Migrations.Answers do
  use Ecto.Migration

  def change do
    create table("answers") do
      add :rating, :integer
      add :author_id, references(:users)
      add :data, :map
      add :comment_ids, {:array, :integer}
      add :inserted_at, :utc_datetime, default: fragment("now()")
    end

  end
end
