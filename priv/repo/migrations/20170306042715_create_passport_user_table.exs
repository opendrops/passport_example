defmodule MyApp.Repo.Migrations.CreateMyApp.Account.User do
  use Ecto.Migration

  def change do
    create table(:account_users) do
      add :email, :string

      timestamps()
    end

    create unique_index(:account_users, [:email])
  end
end
