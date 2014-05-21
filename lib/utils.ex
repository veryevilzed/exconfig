defmodule ExConfig.Utils do
  
  def to_atom(b) when is_atom(b), do: b
  def to_atom(b) when is_binary(b), do: binary_to_atom(b)
  #Преобразовывает массив [{"k","v"}, ...] в [{:k, "v"}, ...]
  def process_dict(d) when is_list(d), do: d |> Enum.map fn({k, v}) -> {to_atom(k), process_dict(v)};(item) -> item end
  def process_dict(d), do: d

end