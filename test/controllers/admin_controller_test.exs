defmodule Welcome.AdminControllerTest do
  use Welcome.ConnCase

  alias Welcome.Repo
  alias Welcome.User

  @valid_attrs %{email: "bill@mail.com", password: "^hEsdg*F899", role: "user"}
  @invalid_attrs %{email: "albert@mail.com", password: "password"}

  setup %{conn: conn} do
    conn = conn |> bypass_through(Welcome.Router, :browser) |> get("/")
    admin_conn = conn |> put_session(:user_id, 1) |> send_resp(:ok, "/")

    {:ok, %{conn: conn, admin_conn: admin_conn}}
  end

  test "GET /admin for authorized user", %{admin_conn: admin_conn} do
    conn = get(admin_conn, admin_path(admin_conn, :index))
    assert html_response(conn, 200)
  end

  test "GET /admin redirect for unauthorized user", %{conn: conn}  do
    conn = conn |> get(admin_path(conn, :index))
    assert redirected_to(conn) == login_path(conn, :login)
  end

  test "creates and returns user when data is valid", %{admin_conn: admin_conn} do
    conn = post admin_conn, admin_path(admin_conn, :create), user: @valid_attrs
    assert redirected_to(conn) == admin_path(conn, :index)
    assert Repo.get_by(User, %{email: "bill@mail.com"})
  end

  test "does not create user when data is invalid", %{admin_conn: admin_conn} do
    conn = post admin_conn, admin_path(admin_conn, :create), user: @invalid_attrs
    assert html_response(conn, 200)
    refute Repo.get_by(User, %{email: "albert@mail.com"})
  end

  test "delete user", %{admin_conn: admin_conn} do
    user = Repo.get(User, 3)
    conn = admin_conn |> delete(admin_path(admin_conn, :delete, user))
    assert redirected_to(conn) == admin_path(conn, :index)
    refute Repo.get(User, user.id)
  end

end
