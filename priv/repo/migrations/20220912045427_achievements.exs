defmodule SchoolWars.Repo.Migrations.Achievements do
  use Ecto.Migration

  def change do
    create table("achievements") do
      add :content, :string
      add :count, :integer
      add :inserted_at, :utc_datetime, default: fragment("now()")
    end

  end
end
