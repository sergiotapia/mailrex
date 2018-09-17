defmodule Mailrex.MailerTest do
  use ExUnit.Case
  doctest Mailrex.Mailer
  alias Mailrex.Mailer

  test "returns error if `to` param is nil or empty string" do
    email_params = %{to: nil, subject: "Example", body: "<p>example</p>", template: ""}
    email_params2 = %{to: "", subject: "Example", body: "<p>example</p>", template: ""}

    assert Mailer.send_email(email_params) == {:error, "To param cannot be nil or empty string"}
    assert Mailer.send_email(email_params2) == {:error, "To param cannot be nil or empty string"}
  end

  test "returns error if `subject` param is nil or empty string" do
    email_params = %{to: "sergio@email.com", subject: nil, body: "<p>example</p>", template: ""}
    email_params2 = %{to: "sergio@email.com", subject: "", body: "<p>example</p>", template: ""}

    assert Mailer.send_email(email_params) ==
             {:error, "Subject param cannot be nil or empty string"}

    assert Mailer.send_email(email_params2) ==
             {:error, "Subject param cannot be nil or empty string"}
  end

  test "returns error if `body` and `template` params are both empty and nil" do
    email_params = %{to: "sergio@email.com", subject: "Example", body: nil, template: ""}
    email_params2 = %{to: "sergio@email.com", subject: "Example", body: nil, template: nil}
    email_params3 = %{to: "sergio@email.com", subject: "Example", body: "", template: ""}
    email_params4 = %{to: "sergio@email.com", subject: "Example", body: "", template: nil}

    assert Mailer.send_email(email_params) == {:error, "body or template param must be set"}
    assert Mailer.send_email(email_params2) == {:error, "body or template param must be set"}
    assert Mailer.send_email(email_params3) == {:error, "body or template param must be set"}
    assert Mailer.send_email(email_params4) == {:error, "body or template param must be set"}
  end

  test "returns content for templates properly" do
    assert Mailer.fetch_template_body("password_reset_email") ==
             {:ok, Mailrex.Templates.PasswordResetEmail.content()}

    assert Mailer.fetch_template_body("welcome_email") ==
             {:ok, Mailrex.Templates.WelcomeEmail.content()}
  end

  test "returns error for nonexisting template" do
    assert Mailer.fetch_template_body("asdf") == {:error, "Template does not exist"}
  end

  test "replaces merge vars in email templates" do
    html_body = "<p>*|username|* is signed in at *|date|*.</p>"

    result = Mailer.replace_merge_vars(html_body, %{username: "sergio", date: "10/10/2010"})
    assert result == {:ok, "<p>sergio is signed in at 10/10/2010.</p>"}
  end

  test "ignores tags that aren't in the templates" do
    html_body = "<p>*|username|* registered!</p>"

    result = Mailer.replace_merge_vars(html_body, %{username: "sergio", location: "Miami"})
    assert result == {:ok, "<p>sergio registered!</p>"}
  end
end
