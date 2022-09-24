defmodule SchoolWars.Repo.Migrations.Users do
  use Ecto.Migration

  def change do
    create table("users") do
      add :login, :string
      add :hash, :binary
      add :data, :map
      add :ratings, :map
      add :roles, {:array, :string}
      add :comment_ids, {:array, :integer}
      add :inserted_at, :utc_datetime, default: fragment("now()")
    end

    create index("users", [:login], unique: true)
  end
end
