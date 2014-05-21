defmodule ExConfig do
  defmacro __using__(_opts) do

    quote location: :keep do
      defmodule Config do

          unquote do
            Dict.get(Mix.Project.config, :config_files, []) |> Enum.map fn({confkey, file}) ->
              {:ok, toml} = :etoml.parse(File.read!(file))
              IO.puts "Create config :#{confkey} from file #{file}, toml: #{toml}"
              toml |> ExConfig.Utils.process_dict |> Enum.map fn({key, value}) ->
                  quote do
                    def env(unquote(confkey), unquote(ExConfig.Utils.to_atom(key)), _), do: unquote(value)
                    def env(unquote(confkey), unquote(ExConfig.Utils.to_atom(key))), do: unquote(value)
                    def unquote(:"#{key}")(), do: unquote(value)
                    IO.puts "Create method :#{key} with #{inspect value}"
                  end;
              end #Enum toml
            end #Enum.map Dict
          end #unquote

          def env(_, _), do: :error
          def env(_, _, default), do: default

          @doc """
          Get value for key in default group
          """
          def env(key), do: env(:base, key)

          @doc """
          Get group data
          """
          def get(group, key), do: Dict.get(env(group), key)
          def get(group, key, default), do: Dict.get(env(group), key, default)

          @doc """
          Get all keys for default group
          """
          def keys(group), do: Dict.keys(env(group))

      end #end defmodule
    end #end quote
  end #end defmacro
end # end defmodule ExConfig