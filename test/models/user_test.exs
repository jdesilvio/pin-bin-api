defmodule Blaces.UserTest do
  use Blaces.DataCase

  alias Blaces.User

  @valid_attrs %{email: "moe@stooges.com", password: "abc123", username: "moe"}
  @invalid_attrs %{}

  describe "changeset/2" do
    test "changeset with valid attributes" do
      changeset = User.changeset(%User{}, @valid_attrs)
      assert changeset.valid?
    end

    test "changeset with invalid attributes" do
      changeset = User.changeset(%User{}, @invalid_attrs)

      refute changeset.valid?

      errors = changeset.errors
      {email_error, _} = errors[:email]
      {username_error, _} = errors[:username]
      {password_error, _} = errors[:password]

      assert email_error == "can't be blank"
      assert username_error == "can't be blank"
      assert password_error == "can't be blank"
    end
  end

  describe "registration_changeset/2" do
    test "registration_changeset with valid attributes" do
      changeset = User.registration_changeset(%User{}, @valid_attrs)
      assert changeset.valid?
    end

    test "registration_changeset with short password" do
      attrs = Map.put(@valid_attrs, :password, "abc")
      changeset = User.registration_changeset(%User{}, attrs)

      refute changeset.valid?

      errors = changeset.errors
      {password_error, params} = errors[:password]
      assert password_error == "should be at least %{count} character(s)"
      assert params[:count] == 6
      assert params[:validation] == :length
      assert params[:min] == 6
    end

    test "registration_changeset with long password" do
      long_password = String.duplicate("a", 101)
      attrs = Map.put(@valid_attrs, :password, long_password)
      changeset = User.registration_changeset(%User{}, attrs)

      refute changeset.valid?

      errors = changeset.errors
      {password_error, params} = errors[:password]
      assert password_error == "should be at most %{count} character(s)"
      assert params[:count] == 100
      assert params[:validation] == :length
      assert params[:max] == 100
    end
  end
end
