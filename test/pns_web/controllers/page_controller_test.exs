defmodule PnsWeb.PageControllerTest do
  use PnsWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Hackathon 2020!"
  end
end
