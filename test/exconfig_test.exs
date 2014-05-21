defmodule ExconfigTest do
  use ExUnit.Case
  use Config

  test "Config" do
    IO.puts Config.env :mysql
  end
end
