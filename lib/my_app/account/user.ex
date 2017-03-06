defmodule MyApp.Account.User do
  use Ecto.Schema

  schema "account_users" do
    field :email, :string

    timestamps()
  end
end
