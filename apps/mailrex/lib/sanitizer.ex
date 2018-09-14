defmodule Mailrex.Sanitizer do
  @doc """
  Cleans up the HTML by only allowing very basic HTML tags,
  removing script tags and extra elements.

  ## Examples

      iex> Mailrex.Sanitizer.sanitize_html("<p>test</p>")
      "<p>test</p>"

  """
  @spec sanitize_html(String.t()) :: String.t()
  def sanitize_html(html) do
    HtmlSanitizeEx.basic_html(html)
  end

  @doc """
  Converts html to a pure text representation for older clients
  and backwards compatability.

  ## Examples

      iex> Mailrex.Sanitizer.html_to_text("<p>Hello world!</p>")
      "Hello world!"

  """
  @spec html_to_text(String.t()) :: String.t()
  def html_to_text(html) do
    HtmlSanitizeEx.strip_tags(html)
  end
end
