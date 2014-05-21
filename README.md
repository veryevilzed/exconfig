# Exconfig


exconfig представляет собой библиотеку, которая позволяет представлять описанные в формате TOML (Tom's Obvious, Minimal Language)[1] данные в программах на Elixir естественным для данного языка образом. Основными достоинствами формата конфигурационных файлов TOML являются минималистичность и удобочитаемость. TOML напоминает формат конфигурационных файлов INI[2], но в отличии от него поддерживает группировку параметров с любым уровнем вложенности. В качестве зависимости exconfig использует библиотеку etoml[3], которая является одним из парсеров TOML на Erlang. (Также существует огромное количество парсеров TOML на других языках программирования[4].)


## Установка

Для установки exconfig необходимо указать его в списке зависимостей целевого проекта. Список конфигурационных файлов в формате TOML указывается наряду с другими параметрами в словаре, который хранит параметры конфигурации проекта. Таким образом, файл mix.exs должен выглядеть примерно следующим образом.



```
# mix.exs

defmodule Demo.Mixfile do
  use Mix.Project

  def project do
    [
      app: :demo,
      version: "0.0.1",
      elixir: "~> 0.13.2",
      config_files: [
        base: "base.toml"
      ],
      deps: deps
    ]
  end

  def application do
    [applications: []]
  end

  defp deps do
    [
      {:exconfig, github: "veryevilzed/exconfig"},
    ]
  end
end


```

## Использование

Предположим, что конфигурационный файл base.toml имеет следующее содержимое.


```
# base.toml

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


Также можно иметь несколько конфигурационных файлов и переключаться между ними в нужный момент времени. К примеру, если параметры подключения к локальному серверу баз данных, который используется для тестирования, отличаются от параметров подключения к удаленному серверу баз данных, который используется для работы системы на предприятии, то можно создать два конфигурационных файла base_local.toml и base_prod.toml, которые будут хранить настройки локального и удаленного серверов баз данных соответственно. Для того чтобы иметь удобную возможность переключения межу ними, необходимо использовать динамическое имя конфигурационного файла, чтобы оно принимало нужное значение в нужный момент времени. Таким образом, если в списке конфигурационных файлов заменить base.toml на base_#{Mix.env}.toml, то можно изменять значени Mix.env во время сборки проекта через переменную окружения MIX_ENV. К примеру, сборка проекта следующим образом

```
MIX_ENV=local iex -S mix
```

или

```
MIX_ENV=prod iex -S mix
```

заставит проект использовать нужный конфигурационный файл.

Примечания:

```
[1] https://github.com/mojombo/toml#toml
[2] http://en.wikipedia.org/wiki/INI_file
[2] https://github.com/kalta/etoml
[3] https://github.com/mojombo/toml#implementations
```

