defmodule Mastery.Boundary.TemplateValidator do
  import Mastery.Boundary.Validator

  def errors(field) when is_list(field) do
    fields = Map.new(field)

    []
    |> require(fields, :name, &validate_name/1)
    |> require(fields, :category, &validate_name/1)
    |> optional(fields, :instructions, &validate_instructions/1)
    |> require(fields, :raw, &validate_raw/1)
    |> require(fields, :generators, &validate_generators/1)
    |> require(fields, :checker, &validate_checker/1)
  end

  def errors(field), do: [{nil, "A keyword list of fields is required"}]

  def validate_name(name) when is_atom(name), do: :ok
  def validate_name(_name), do: {:error, "must be an atom"}

  def validate_instructions(instructions) when is_binary(instructions), do: :ok
  def validate_instructions(_instructions), do: {:error, "must be binary"}

  def validate_raw(raw) when is_binary(raw) do
    check(String.match?(raw, ~r{\S}), {:error, "can't be blank"})
  end

  def validate_raw(_raw), do: {:error, "must be string"}

  def validate_generators(generators) when is_map(generators) do
    generators
    |> Enum.map(&validate_generators/1)
    |> Enum.reject(&(&1 == :ok))
    |> case do
      [] ->
        :ok

      errors ->
        {:errors, errors}
    end
  end

  def validate_generators(_generators), do: {:error, "must be a map"}

  def validate_generators({name, generator}) when is_atom(name) and is_list(generator) do
    check(generator != [], {:error, "can't be empty"})
  end

  def validate_generators({name, generators}) when is_atom(name) and is_function(generators, 0) do
    :ok
  end

  def validate_generators(_generators), do: {:error, "must be a string to list or function pair"}
  def validate_checker(checker) when is_function(checker, 2), do: :ok
  def validate_checker(_checker), do: {:error, "must be an arity 2 function"}
end
