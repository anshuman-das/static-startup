defmodule PnsWeb.Router do
  use PnsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/auth", PnsWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  scope "/", PnsWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/logout", AuthController, :delete

    pipe_through PnsWeb.Plugs.Auth

    resources "/applications", ApplicationController do
      resources "/events", EventController
    end
  end

  scope "/api", PnsWeb do
    pipe_through :api

    get "/event/:key", Api.EventController, :get_event_by_key
  end
end
