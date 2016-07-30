defmodule Welcome.UserControllerTest do
  use Welcome.ConnCase

  alias Welcome.Repo
  alias Welcome.User

  @valid_attrs %{email: "bill@mail.com", password: "^hEsdg*F899", role: "user"}
  @invalid_attrs %{email: "albert@mail.com", password: "password"}

  setup %{conn: conn} do
    conn = conn |> bypass_through(Welcome.Router, :browser) |> get("/")
    user_conn = conn |> put_session(:user_id, 2) |> send_resp(:ok, "/")

    {:ok, %{conn: conn, user_conn: user_conn}}
  end

  test "GET /users for authorized user", %{user_conn: user_conn} do
    conn = get user_conn, user_path(user_conn, :index)
    assert html_response(conn, 200)
  end

  test "GET /users redirect for unauthorized user", %{conn: conn}  do
    conn = conn |> get(user_path(conn, :index))
    assert redirected_to(conn) == login_path(conn, :login)
  end

  test "GET /users/:id", %{user_conn: user_conn} do
    user = Repo.get(User, 2)
    conn = get user_conn, user_path(user_conn, :show, user)
    assert html_response(conn, 200)
  end

  test "GET /users/:id/edit", %{user_conn: user_conn} do
    user = Repo.get(User, 2)
    conn = get user_conn, user_path(user_conn, :edit, user)
    assert html_response(conn, 200)
  end

  test "GET /users/:id/edit redirect for other user", %{user_conn: user_conn} do
    user = Repo.get(User, 3)
    conn = get user_conn, user_path(user_conn, :edit, user)
    assert redirected_to(conn) == user_path(conn, :index)
  end

  test "PUT /users/:id with valid data", %{user_conn: user_conn} do
    user = Repo.get(User, 2)
    conn = put user_conn, user_path(user_conn, :update, user), user: @valid_attrs
    assert redirected_to(conn) == user_path(conn, :index)
  end

  test "PUT /users/:id with invalid data", %{user_conn: user_conn} do
    user = Repo.get(User, 2)
    conn = put user_conn, user_path(user_conn, :update, user), user: @invalid_attrs
    assert redirected_to(conn) == user_path(conn, :index)
  end

end
