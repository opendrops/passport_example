defmodule MyApp.Repo.Migrations.CreateMyApp.Auth.Password do
  use Ecto.Migration

  def change do
    create table(:auth_passwords) do
      add :password_hash, :string
      add :user_id, :integer

      timestamps()
    end

    create index(:auth_passwords, [:user_id])
  end
end
