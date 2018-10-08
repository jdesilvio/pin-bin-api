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

  def bin_factory do
    %PinBin.Bin{
      id: sequence(:id, &(&1 + 1)),
      name: sequence(:name, &"bin-#{&1 + 1}"),
      short_name: sequence(:short_name, &"bin-#{&1 + 1}"),
      user: build(:user)
    }
  end

  def pin_factory do
    %PinBin.Pin{
      id: sequence(:id, &(&1 + 1)),
      name: sequence(:name, &"pin-#{&1 + 1}"),
      latitude: 99.99,
      longitude: 11.11,
      user: build(:user),
      bin: build(:bin)
    }
  end
end
