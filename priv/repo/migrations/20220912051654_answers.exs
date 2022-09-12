defmodule SchoolWars.Repo.Migrations.Answers do
  use Ecto.Migration

  def change do
    create table("answers") do
      add :content, :string
      add :rating, :integer
      add :author, references(:users)
      add :data, :map
      add :comments, {:array, :integer}
      add :inserted_at, :utc_datetime, default: fragment("now()")
    end

  end
end
