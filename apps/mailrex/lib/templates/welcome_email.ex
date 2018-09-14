defmodule Mailrex.Templates.WelcomeEmail do
  def content() do
    """
    <p>Welcome *|username|*!</p>
    """
  end
end
