defmodule ApiWeb.Plug.ApiAuthenticate do
  import Plug.Conn

  def init(default), do: default

  # This is a dummy implementation of authentication with a token
  # for API access. For now as long any token is set, it'll count
  # as authenticated.
  def call(conn, _opts) do
    conn = fetch_query_params(conn)

    with token when is_binary(token) <- conn.params["token"] do
      conn
      |> authenticate_user(%{id: 1, username: "someuser"})
    else
      nil ->
        conn
        |> put_status(:forbidden)
        |> Phoenix.Controller.json(%{message: "You are not authorized to access this resource."})
        |> halt
    end
  end

  defp authenticate_user(conn, user) do
    conn
    |> assign(:current_user, user)
  end
end
