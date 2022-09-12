defmodule SchoolWars.Repo.Migrations.Users do
  use Ecto.Migration

  def change do
    create table("users") do
      add :login, :string
      add :hash, :binary
      add :data, :map
      add :comments, {:array, :integer}
      add :inserted_at, :utc_datetime, default: fragment("now()")
    end

    create index("users", [:login], unique: true)

  end
end
