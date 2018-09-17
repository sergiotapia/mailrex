defmodule ApiWeb.Api.V1.MailController do
  use ApiWeb, :controller

  def index(conn, _params) do
    emails = [%{to: "a@email.com", from: "b@email.com", status: "pending"}]
    json(conn, emails)
  end

  def create(conn, params) do
    merge_vars =
      try do
        Enum.reduce(params["merge_vars"], %{}, fn string_var, merge_vars ->
          [name, value] = String.split(string_var, "|")
          Map.put(merge_vars, String.to_atom(name), value)
        end)
      rescue
        _ ->
          %{}
      end

    email_params = %{
      to: params["to"],
      subject: params["subject"],
      body: params["body"],
      template: params["template"],
      merge_vars: merge_vars
    }

    with {:ok, email = %Bamboo.Email{}} <- Mailrex.Mailer.send_email(email_params) do
      json(conn, "Email sent")
    else
      {:error, message} ->
        conn
        |> put_status(422)
        |> json(%{error: message})
    end
  end
end
