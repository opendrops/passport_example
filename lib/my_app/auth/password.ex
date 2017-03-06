defmodule MyApp.Auth.Password do
  use Ecto.Schema

  schema "auth_passwords" do
    field :password_hash, :string
    field :user_id, :integer

    timestamps()
  end
end
