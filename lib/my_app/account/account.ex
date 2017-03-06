defmodule MyApp.Account.Registration do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :email
    field :password
  end

end

defmodule MyApp.Account do
  @behaviour Passport.Account
  import Ecto.{Query, Changeset}, warn: false
  alias MyApp.Repo
  alias MyApp.Account.User
  alias MyApp.Auth
  alias MyApp.Account.Registration

  def get_user(id), do: Repo.get(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> user_changeset(attrs)
    |> Repo.insert()
  end

  defp user_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
    |> unique_constraint(:email)
  end

  def new_registration do
    registration_changeset(%Registration{}, %{})
  end

  def create_registration(attrs \\ %{}) do
    changeset = registration_changeset(%Registration{}, attrs)
    with true <- changeset.valid?,
      registration = Ecto.Changeset.apply_changes(changeset) do
      Repo.transaction fn ->
         case create_user(Map.take(registration, [:email])) do
           {:ok, user} ->
             Auth.create_password(%{password: registration.password, user_id: user.id})
           {:error, error} ->
             %{changeset | errors: error.errors, action: :insert}
              |> Repo.rollback
         end
       end
     else
       _ -> {:error, %{changeset | action: :insert}}
     end
  end

  defp registration_changeset(%Registration{} = registration, attrs) do
    registration
    |> cast(attrs, [:email, :password])
    |> validate_confirmation(:password, required: true)
    |> validate_required([:email])
    |> validate_format(:email, ~r/.+@.+/)
  end

end
