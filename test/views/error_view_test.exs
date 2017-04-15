defmodule Blaces.ErrorViewTest do
  use Blaces.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(Blaces.ErrorView, "404.html", []) ==
           "Page not found"
  end

  test "render 500.html" do
    assert render_to_string(Blaces.ErrorView, "500.html", []) ==
           "Internal server error"
  end

  test "render any other" do
    assert render_to_string(Blaces.ErrorView, "505.html", []) ==
           "Internal server error"
  end

  test "render error.json" do
    assert render(Blaces.ErrorView, "error.json", %{reason: :some_reason}) ==
      %{error: %{reason: :some_reason}}
  end
end
