defmodule Phxbook.Router do
  use Phxbook.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Phxbook.Auth, repo: Phxbook.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Phxbook do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController, only: [:index, :show, :new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/manage", Phxbook do
    pipe_through [:browser, :authenticate_user]

    resources "/videos", VideoController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Phxbook do
  #   pipe_through :api
  # end
end
