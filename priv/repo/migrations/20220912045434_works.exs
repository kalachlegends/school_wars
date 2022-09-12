defmodule SchoolWars.Repo.Migrations.Works do
  use Ecto.Migration

  def change do
    create table("works") do
      add :content, :string
      add :rating, :integer
      add :status, :integer
      add :author, references(:users)
      add :data, :map
      add :answers, {:array, :integer}
      add :comments, {:array, :integer}
      add :inserted_at, :utc_datetime, default: fragment("now()")
    end

  end
end
