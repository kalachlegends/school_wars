defmodule SchoolWars.Repo.Migrations.Comments do
  use Ecto.Migration

  def change do
    create table("comments") do
      add :content, :string
      add :rating, :integer
      add :author, references(:users)
      add :inserted_at, :utc_datetime, default: fragment("now()")
    end

  end
end
