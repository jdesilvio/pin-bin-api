defmodule PinBinWeb.ErrorViewTest do
  use PinBinWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json" do
    assert render(PinBinWeb.ErrorView, "404.json", []) ==
           %{
             status: :error,
             message: "An error occurred.",
             errors: %{
               detail: "Page not found"
             }
           }
  end

  test "render 500.json" do
    assert render(PinBinWeb.ErrorView, "500.json", []) ==
           %{
             status: :error,
             message: "An error occurred.",
             errors: %{
               detail: "Internal server error"
             }
           }
  end

  test "render any other" do
    assert render(PinBinWeb.ErrorView, "505.json", []) ==
           %{
             status: :error,
             message: "An error occurred.",
             errors: %{
               detail: "Internal server error"
             }
           }
  end

  test "render error.json" do
    changeset = %Ecto.Changeset{
      types: %{},
      errors: [
        something: {
          "can't be blank",
          [validation: :required]
        }
      ]
    }
    assert render(PinBinWeb.ErrorView, "error.json", %{changeset: changeset}) ==
           %{
             errors: %{something: ["can't be blank"]},
             message: "An error occurred.",
             status: :error
           }
  end
end
