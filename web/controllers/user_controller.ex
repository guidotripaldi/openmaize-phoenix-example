defmodule Welcome.UserController do
  use Welcome.Web, :controller

  import Welcome.Authorize
  alias Welcome.User

  plug :scrub_params, "user" when action in [:update]
  plug :id_check when action in [:show, :edit, :update]

  def action(conn, _), do: authorize_role_dbcheck conn, ["admin", "user"], __MODULE__

  def index(conn, _params, _user) do
    render conn, "index.html"
  end

  def show(conn, _params, user) do
    render(conn, "show.html", user: user)
  end

  def edit(conn, _params, user) do
    changeset = User.changeset(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"user" => user_params}, user) do
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User page updated successfully.")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end
end
