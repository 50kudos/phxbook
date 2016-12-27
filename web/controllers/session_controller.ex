defmodule Phxbook.SessionController do
  use Phxbook.Web, :controller
  alias Phxbook.Auth

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => session}) do
    %{"username" => username, "password" => password} = session
    case IO.inspect Auth.login(conn, username, password, repo: Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: page_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid username or password")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Auth.logout
    |> redirect(to: page_path(conn, :index))
  end
end
