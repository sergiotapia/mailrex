defmodule Mailrex.Mailer do
  use Bamboo.Mailer, otp_app: :mailrex
  import Bamboo.Email

  @type email_params :: %{
          to: String.t(),
          subject: String.t(),
          body: String.t(),
          template: String.t(),
          merge_vars: Map.t()
        }

  @doc """
  Send an email using Mailgun's API with the provided details.
  """
  @spec send_email(email_params) :: {:ok, String.t()}
  def send_email(%{to: to} = email_params) when is_nil(to) or byte_size(to) == 0 do
    {:error, "To param cannot be nil or empty string"}
  end

  def send_email(%{subject: subject} = email_params)
      when is_nil(subject) or byte_size(subject) == 0 do
    {:error, "Subject param cannot be nil or empty string"}
  end

  def send_email(%{body: body, template: template} = email_params)
      when is_nil(body) and is_nil(template) do
    {:error, "body or template param must be set"}
  end

  def send_email(%{body: body, template: template} = email_params)
      when is_nil(body) and byte_size(template) == 0 do
    {:error, "body or template param must be set"}
  end

  def send_email(%{body: body, template: template} = email_params)
      when byte_size(body) == 0 and is_nil(template) do
    {:error, "body or template param must be set"}
  end

  def send_email(%{body: body, template: template} = email_params)
      when byte_size(body) == 0 and byte_size(template) == 0 do
    {:error, "body or template param must be set"}
  end

  def send_email(%{body: body} = email_params) when byte_size(body) > 0 do
    email_body = Mailrex.Sanitizer.sanitize_html(email_params.body)
    email_text_body = Mailrex.Sanitizer.html_to_text(email_params.body)

    # Sandbox Mailgun environments only allow you to send emails
    # to Authorized Recipients. This means that the "to" param cannot
    # be dyanmic as the spec requires.

    # In production, we would call `to(email_params.to)` - but for now
    # it will be hardcoded to my email address which has been authorized.

    new_email
    |> to("sergiotapia@outlook.com")
    |> from("mailrex@nanote.io")
    |> subject(email_params.subject)
    |> html_body(email_body)
    |> text_body(email_text_body)
    |> deliver_later()

    # Currently sending is not working from my local machine because mailgun has
    # banned my ISP.

    # Failed: postmaster@sandbox0b6591de7094460198de50bee46868d2.mailgun.org →
    # sergiotapia@outlook.com 'Example email.' Server response: 550 5.7.1
    # Unfortunately, messages from [209.61.151.224] weren't sent. Please contact
    # your Internet service provider since part of their network is on our block
    # list (S3140). You can also refer your provider
    # to http://mail.live.com/mail/troubleshooting.aspx#errors. [HE1EUR01FT027.eop-
    # EUR01.prod.protection.outlook.com]
  end

  def send_email(email_params) do
    email_body =
      email_params.template
      |> fetch_template_body
      |> replace_merge_vars(email_params.merge_vars)

    email_text_body = Mailrex.Sanitizer.html_to_text(email_body)

    new_email
    |> to("sergiotapia@outlook.com")
    |> from("mailrex@nanote.io")
    |> subject(email_params.subject)
    |> html_body(email_body)
    |> text_body(email_text_body)
    |> deliver_later()
  end

  def fetch_template_body(template_name) do
    case template_name do
      "password_reset_email" ->
        Mailrex.Templates.PasswordResetEmail.content()

      "welcome_email" ->
        Mailrex.Templates.WelcomeEmail.content()

      _ ->
        ""
    end
  end

  def replace_merge_vars(html_body, merge_vars) do
    Enum.reduce(merge_vars, html_body, fn item, html_body ->
      {merge_var, value} = item
      String.replace(html_body, "*|#{Atom.to_string(merge_var)}|*", value, global: true)
    end)
  end
end
