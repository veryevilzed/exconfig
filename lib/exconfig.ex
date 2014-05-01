defmodule ExConfig do
  defmacro __usinf__(_opts) do

    quote do
      defmodule Config do


          Dict.get(Mix.Project.config, :config_files, []) |> Enum.map fn({confkey, file}) ->
            IO.puts "Create config :#{confkey} from file #{file}"
            {:ok, toml} = :etoml.parse(File.read!(file))
            toml |> Enum.map fn({key, value}) ->
              quote do 
                def env(unquote(confkey), unquote(binary_to_atom(key))), do: unquote(value)  
                def unquote(:"#{key}")(), do: unquote(value)
              end
            end
          end

          def env(_, _), do: :error

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