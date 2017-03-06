defmodule MyApp.Web.RegistrationController do
  use MyApp.Web, :controller
  alias MyApp.Account

  def new(conn, _params) do
    changeset = Account.new_registration()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"registration" => user_params}) do
    case Account.create_registration(user_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Registration successful.")
        |> redirect(to: page_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
