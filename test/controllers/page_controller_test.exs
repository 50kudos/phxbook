defmodule Phxbook.PageControllerTest do
  use Phxbook.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Welcome to phoenix book learning"
  end
end
