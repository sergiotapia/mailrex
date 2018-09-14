defmodule ApiWeb.Router do
  use ApiWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :authenticated_api do
    plug(:accepts, ["json"])
    plug(ApiWeb.Plug.ApiAuthenticate)
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", ApiWeb.Api.V1, as: :api_v1 do
    pipe_through(:authenticated_api)

    get("/mails", MailController, :index)
    post("/mails", MailController, :create)
  end
end
