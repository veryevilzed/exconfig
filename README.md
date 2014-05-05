# Exconfig


Setup:

```
# mix.exs

defmodule MyApp.Mixfile do
  use Mix.Project

  def project do
    [
     app: :myapp,
     version: "0.0.1",
     deps: deps,
     env: [dev: dev]
    ]
  end

  def application do
    [ applications: [] ]
  end

  def dev, do: [
    # Set config files for dev env.
    config_files: [
      base: "contrib/base.toml"
    ]
  ]

  defp deps do
    [
      { :exconfig, github: "veryevilzed/exconfig" }
    ]
  end
end

```

Usage:

```
# contrub/base.toml

[mysql]
    database = "mydb"
    host = "myhost"
    user = "myuser"
    passwd = "mypassword"

```

```
iex()> use ExConfig

iex()> Config.mysql
[{"passwd", "mypassword"}, {"user", "myuser"}, {"host", "myhost"},
 {"database", "mydb"}]

iex()> Config.get :mysql, "user"
"myuser"

iex()> Config.get :mysql, "port", 3306
3306

iex()> Config.keys :mysq
["passwd", "user", "host", "database"]


iex()> Config.env :base, :mysql
[{"passwd", "mypassword"}, {"user", "myuser"}, {"host", "myhost"},
 {"database", "mydb"}]

iex()> Config.env(:mysql) == Config.mysql
true


```