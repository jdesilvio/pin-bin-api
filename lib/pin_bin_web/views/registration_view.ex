defmodule PinBinWeb.RegistrationView do
  use PinBinWeb, :view

  def render("success.json", %{user: user, resource: resource}) do
    %{
      status: :ok,
      message: """
        Now you can sign in using your email and password
        at /api/v1/auth. You will receive a JWT token.
        Please put this token into Authorization header
        for all authorized requests.
      """
    }
  end

  def render("error.json", %{changeset: changeset}) do
    %{
      status: :error,
      message: "An error occurred.",
      errors: translate_errors(changeset)
    }
  end

end
