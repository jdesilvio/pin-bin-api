defmodule Blaces.Factory do
  use ExMachina.Ecto, repo: Blaces.Repo

  def user_factory do
    %Blaces.User{
      id: sequence(:id, &(&1 + 1)),
      username: "Hingle McCringleberry",
      email: sequence(:email, &"email-#{&1}@example.com"),
      password: "abc123"
    }
  end

  def bucket_factory do
    %Blaces.Bucket{
      id: sequence(:id, &(&1 + 1)),
      name: sequence(:name, &"bucket-#{&1 + 1}"),
      user: build(:user)
    }
  end

end
