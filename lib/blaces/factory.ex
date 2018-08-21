defmodule PinBin.Factory do
  use ExMachina.Ecto, repo: PinBin.Repo

  def user_factory do
    password = "abc123"
    password_hash = Comeonin.Bcrypt.hashpwsalt(password)

    %PinBin.User{
      id: sequence(:id, &(&1 + 1)),
      username: sequence(:username, &"Hingle McCringleberry#{&1}"),
      email: sequence(:email, &"email-#{&1}@example.com"),
      password: password,
      password_hash: password_hash
    }
  end

  def bucket_factory do
    %PinBin.Bucket{
      id: sequence(:id, &(&1 + 1)),
      name: sequence(:name, &"bucket-#{&1 + 1}"),
      short_name: sequence(:short_name, &"bucket-#{&1 + 1}"),
      user: build(:user)
    }
  end

  def pin_factory do
    %PinBin.Pin{
      id: sequence(:id, &(&1 + 1)),
      name: sequence(:name, &"pin-#{&1 + 1}"),
      latitude: 99.99,
      latitude: 11.11,
      user: build(:user),
      bucket: build(:bucket)
    }
  end
end
