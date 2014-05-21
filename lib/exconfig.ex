defmodule ExConfig do
  defmacro __using__(_opts) do

    quote location: :keep do
      defmodule Config do

          unquote do
            Dict.get(Mix.Project.config, :config_files, []) |> Enum.map fn({confkey, file}) ->
              IO.puts "Create config :#{confkey} from file #{file}"
              {:ok, toml} = :etoml.parse(File.read!(file))
              toml |> Enum.map fn({key, value}) ->

                #Преобразовывает массив [{"k","v"}, ...] в [{:k, "v"}, ...]
                bin_value = case value do
                  value when is_list(value) -> Enum.map value, 
                      fn ({k,v}) when is_atom(k) -> {k, v};
                      ({k,v}) -> { binary_to_atom(k), v };
                      (item)  -> item end
                  value -> value
                end
                quote do
                  def env(unquote(confkey), unquote(binary_to_atom(key)), _), do: unquote(bin_value)
                  def env(unquote(confkey), unquote(binary_to_atom(key))), do: unquote(bin_value)

                  def unquote(:"#{key}")(), do: unquote(bin_value)
                end
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