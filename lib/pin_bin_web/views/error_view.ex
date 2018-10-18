defmodule PinBinWeb.ErrorView do
  use PinBinWeb, :view

  def render("404.json", _assigns) do
    "Page not found"
  end

  def render("500.json", _assigns) do
    "Internal server error"
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.json", assigns
  end

  def render("error.json", %{reason: reason}) do
    %{
      status: :error,
      message: "An error occurred.",
      errors: translate_errors(reason)
    }
  end
end
