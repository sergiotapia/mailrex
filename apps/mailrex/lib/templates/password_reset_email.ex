defmodule Mailrex.Templates.PasswordResetEmail do
  def content() do
    """
    <p>Reset your password here *|username|*!</p>
    <a href="*|resetPasswordLink|*">Reset password here</a>
    """
  end
end
