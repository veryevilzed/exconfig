
defmodule Config do
  Dict.get(Mix.Project.config, :config_files, []) |> Enum.each fn({confkey, file}) ->
      {:ok, toml} = :etoml.parse(File.read!(file))
      IO.puts "Create Config.#{String.capitalize(atom_to_binary(confkey))}"
      

    toml |> Enum.each fn({key, value}) ->
      def env(unquote(confkey), unquote(binary_to_atom(key))), do: unquote(value)  
      
      def unquote(:"#{key}")() do
        unquote(value)
      end
    
    end
  end


  def env(_, _), do: :error
  def env(key), do: env(:base, key)

  @doc """
  Получить данные группы
  """
  def get(group, key), do: Dict.get(env(group), key)
  def get(group, key, default), do: Dict.get(env(group), key, default)

  @doc """
  Получить список ключей группы
  """
  def keys(group), do: Dict.keys(env(group))

end

