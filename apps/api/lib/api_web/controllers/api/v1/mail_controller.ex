defmodule ApiWeb.Api.V1.MailController do
  use ApiWeb, :controller

  def index(conn, _params) do
    emails = [%{to: "a@email.com", from: "b@email.com", status: "pending"}]
    json(conn, emails)
  end

  def create(conn, params) do
    IO.inspect(params)

    merge_vars =
      Enum.reduce(params["merge_vars"], %{}, fn string_var, merge_vars ->
        [name, value] = String.split(string_var, "|")
        Map.put(merge_vars, String.to_atom(name), value)
      end)

    email_params = %{
      to: params["to"],
      subject: params["subject"],
      body: params["body"],
      template: params["template"],
      merge_vars: merge_vars
    }

    result = Mailrex.Mailer.send_email(email_params)
    json(conn, "Email sent.")
  end
end
