defmodule SchoolWars.Repo.Migrations.Works do
  use Ecto.Migration

  def change do
    create table("works") do
      add :status, :string
      add :author_id, references(:users)
      add :data, :map
      add :ratings, :map
      add :answer_ids, {:array, :integer}
      add :comment_ids, {:array, :integer}
      add :inserted_at, :utc_datetime, default: fragment("now()")
    end
  end
end
