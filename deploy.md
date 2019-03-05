# Deploy Pin Bin API

### Adapted from [here](https://devato.com/automate-elixir-phoenix-1-4-deployment-with-distillery-and-edeliver-on-ubuntu/) and [here](https://strongwing.studio/2018/04/09/deploying-a-phoenix-app-to-ubuntu-16-04-with-edeliver-distillery-and-nginx/) and [here](https://medium.com/@zek/deploy-early-and-often-deploying-phoenix-with-edeliver-and-distillery-part-two-f361ef36aa10)

### Switch editor
```bash
sudo update-alternatives --config editor
3
```

### Update locale
```bash
sudo update-locale LC_ALL=en_US.UTF-8
sudo update-locale LANGUAGE=en_US.UTF-8
```

### Create new `deploy` user
#### Set password, keep defaults otherwise
```bash
adduser deploy
```

### Configure `.ssh` directory
```bash
sudo mkdir -p /home/deploy/.ssh
sudo touch /home/deploy/.ssh/authorized_keys
sudo chmod 700 /home/deploy/.ssh
sudo chmod 644 /home/deploy/.ssh/authorized_keys
sudo chown -R deploy:deploy /home/deploy
```

### Verify that password authentication is set to "no"
#### `PasswordAuthentication no`
```bash
sudo vim /etc/ssh/sshd_config
```

### Add `deploy` user to super users
```bash
visudo
```

#### Should look like
```sh
# User privilege specification
root     ALL=(ALL:ALL) ALL
deploy   ALL=(ALL) NOPASSWD: ALL
```

### Add `ssh` key
```bash
cat ~/.ssh/digitalocean_pinbin.pub
```

```bash
sudo vim /home/deploy/.ssh/authorized_keys
```

### Switch to `deploy` user
 ```bash
su deploy
cd
```

### Install `asdf`
```bash
sudo apt-get update
sudo apt-get install -y build-essential git wget libssl-dev libreadline-dev \
  libncurses5-dev zlib1g-dev m4 curl wx-common libwxgtk3.0-dev autoconf \
  libxml2-utils xsltproc fop unixodbc unixodbc-bin unixodbc-dev
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
source ~/.bashrc
asdf
```

### Install `Erlang`
```bash
asdf plugin-add erlang
asdf install erlang 21.1
asdf global erlang 21.1
```

### Install `Elixir`
```bash
asdf plugin-add elixir
asdf install elixir 1.8.0
asdf global elixir 1.8.0
```

### Update `PATH`
```bash
PATH=/home/deploy/.asdf/installs/erlang/21.1/bin:$PATH
```

#### Use `.tool-versions` file to manage which version

### Install `Hex`
```bash
mix local.hex
```

### Install Node.js
```bash
sudo apt install curl
curl -sL https://deb.nodesource.com/setup_8.x | sudo bash -
sudo apt-get install -y nodejs
```


### Install PostgreSQL
#### Switch to `root` user
```bash
sudo apt update
sudo apt install -y postgresql postgresql-contrib
```

#### Create new database user
```bash
su postgres
createuser pinbin --pwprompt
```

#### Create database as `postgres` user
```bash
createdb pin_bin_prod
```

#### Log in to `psql`:
```bash
psql
```

#### Then grant priviledges
```sql
GRANT ALL PRIVILEGES ON DATABASE pin_bin_prod TO pinbin;
```

### Add `prod.secret.exs` with credentials
```bash
su deploy
cd
mkdir -p apps/pin-bin-api/secret
vim ~/apps/pin-bin-api/secret/prod.secret.exs
```

```elixir
use Mix.Config

config :pin_bin, PinBinWeb.Endpoint,
  secret_key_base: "sUpErSeCrEt"

config :pin_bin, PinBin.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "pinbin",
  password: "password",
  database: "pin_bin_prod",
  pool_size: 10
```

### Update local `mix.exs`
```elixir
def application do
  [
    ...,
    applications: [..., :edeliver],
    ...
  ]
end

...

defp deps do
  [
     ...,
     {:edeliver, ">= 1.6.0"},
     {:distillery, "~> 2.0", warn_missing: false},
     ...
  ]
end
```

#### Run: `mix deps.get`

### Add `.edeliver/config`
```sh
#!/bin/bash

APP="pin_bin"

BUILD_HOST="157.230.85.152"
BUILD_USER="deploy"
BUILD_AT="/tmp/edeliver/$APP/builds"

START_DEPLOY=true
CLEAN_DEPLOY=true

# prevent re-installing node modules; this defaults to "."
GIT_CLEAN_PATHS="_build rel priv/static"

PRODUCTION_HOSTS="157.230.85.152"
PRODUCTION_USER="deploy"
DELIVER_TO="/home/deploy/apps"

# For Phoenix projects, symlink prod.secret.exs to our tmp source
pre_erlang_get_and_update_deps() {
  local _prod_secret_path="/home/deploy/apps/$APP/secret/prod.secret.exs"
  if [ "$TARGET_MIX_ENV" = "prod" ]; then
    status "Linking '$_prod_secret_path'"
    __sync_remote "
      [ -f ~/.profile ] && source ~/.profile
      mkdir -p '$BUILD_AT'
      ln -sfn '$_prod_secret_path' '$BUILD_AT/config/prod.secret.exs'
    "
  fi
}

pre_erlang_clean_compile() {
  status "Running npm install"
    __sync_remote "
      [ -f ~/.profile ] && source ~/.profile
      set -e
      cd '$BUILD_AT'/assets
      npm install
    "

  status "Compiling assets"
    __sync_remote "
      [ -f ~/.profile ] && source ~/.profile
      set -e
      cd '$BUILD_AT'/assets
      node_modules/.bin/webpack --mode production --silent
    "

  status "Running phoenix.digest" # log output prepended with "----->"
  __sync_remote " # runs the commands on the build host
    [ -f ~/.profile ] && source ~/.profile # load profile (optional)
    set -e # fail if any command fails (recommended)
    cd '$BUILD_AT' # enter the build directory on the build host (required)
    # prepare something
    mkdir -p priv/static # required by the phoenix.digest task
    # run your custom task
    APP='$APP' MIX_ENV='$TARGET_MIX_ENV' $MIX_CMD phx.digest $SILENCE
    APP='$APP' MIX_ENV='$TARGET_MIX_ENV' $MIX_CMD phx.digest.clean $SILENCE
  "
}
```

### Update `conf/prod.cexs`
```elixir
use Mix.Config

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.
#
# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
config :edapp, EdappWeb.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [host: "157.230.85.152", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  code_reloader: false

# Do not print debug messages in production
config :logger, level: :info

config :phoenix, :serve_endpoints, true
import_config "prod.secret.exs"
```

### Add `ENVVAR`s and set `asdf` shell path in `~/.profile`
```bash
export MIX_ENV=prod
export PORT=4000

. $HOME/.asdf/asdf.sh
```

### Build
```bash
mix edeliver build release production --branch=deploy
```

### Deploy
```bash
mix edeliver deploy release to production
```

### Other useful commands
```bash
mix edeliver ping production # shows which nodes are up and running
mix edeliver version production # shows the release version running on the nodes
mix edeliver show migrations on production # shows pending database migrations
mix edeliver migrate production # run database migrations
mix edeliver restart production # or start or stop
```

## Deploy sequence

### SSH `ssh pin_bin`

### Commands
```bash
mix edeliver build release production --branch=deploy
mix edeliver deploy release to production --version=0.1.0-alpha-8

mix edeliver build upgrade --branch=deploy --with=0.1.0-alpha-8
mix edeliver upgrade production

mix edeliver ping production
mix edeliver version production
```
