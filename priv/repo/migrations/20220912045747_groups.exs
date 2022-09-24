defmodule SchoolWars.Repo.Migrations.Groups do
  use Ecto.Migration

  def change do
    create table("groups") do
      add :name, :string
      add :data, :map
      add :manager_id, references(:users)
      add :group_type, :string
      add :ratings, :map
      add :user_ids, {:array, :integer}
      add :comment_ids, {:array, :integer}
      add :inserted_at, :utc_datetime, default: fragment("now()")
    end

    create index("groups", [:name], unique: true)
  end
end
