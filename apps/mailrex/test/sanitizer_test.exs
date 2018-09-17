defmodule Mailrex.SanitizerTest do
  use ExUnit.Case
  doctest Mailrex.Sanitizer
  alias Mailrex.Sanitizer

  test "leaves proper html untouched" do
    html = """
    <p>Leave this <strong>as is</strong>, thank you!</p>"
    """

    assert Sanitizer.sanitize_html(html) == {:ok, html}
  end

  test "removes script tags" do
    html = """
    <p>Script tags are <script>bad for you</script></p>"
    """

    clean_html = """
    <p>Script tags are bad for you</p>"
    """

    assert Sanitizer.sanitize_html(html) == {:ok, clean_html}
  end

  test "leaves img tags in place" do
    html = """
    <p>Say cheese! <img src="https://i.imgur.com/H37kxPH.jpg" /></p>"
    """

    assert Sanitizer.sanitize_html(html) == {:ok, html}
  end
end
