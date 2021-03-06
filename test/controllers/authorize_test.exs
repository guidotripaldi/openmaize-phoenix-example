defmodule Welcome.AuthorizeTest do
  use Welcome.ConnCase

  import Welcome.OpenmaizeEcto
  alias Welcome.{Repo, User}

  @valid_attrs %{email: "tony@mail.com", password: "mangoes&g0oseberries"}
  @invalid_attrs %{email: "tony@mail.com", password: "maaaangoes&g00zeberries"}

  # In this example setup, `conn` is the connection for an unauthenticated
  # user, and `user_conn` is for an authenticated user (with an id of 3)
  # You will need a similar setup in some of your other controller files,
  # if your tests involve the use of sessions
  setup %{conn: conn} do
    conn = conn |> bypass_through(Welcome.Router, :browser) |> get("/")
    user_conn = conn |> put_session(:user_id, 3) |> send_resp(:ok, "/")

    {:ok, %{conn: conn, user_conn: user_conn}}
  end

  test "login succeeds", %{conn: conn} do
    # Remove the Repo.get_by line if you are not using email confirmation
    Repo.get_by(User, %{email: "tony@mail.com"}) |> user_confirmed
    conn = post conn, "/login", user: @valid_attrs
    assert redirected_to(conn) == "/users"
  end

  test "login fails", %{conn: conn} do
    # Remove the Repo.get_by line if you are not using email confirmation
    Repo.get_by(User, %{email: "reg@mail.com"}) |> user_confirmed
    conn = post conn, "/login", user: @invalid_attrs
    assert redirected_to(conn) == "/login"
  end

  test "logout succeeds", %{user_conn: user_conn} do
    conn = delete user_conn, "/logout"
    assert redirected_to(conn) == "/"
  end

end
