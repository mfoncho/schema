defmodule Schema do
    @moduledoc """
    Data Validation for Elixir.
    """

    alias Schema.{
        Extract,
        InvalidValidatorError,
        Validator,
        Validator.Source
    }

    def valid?(data) do
        valid?(data, Extract.settings(data))
    end

    def valid?(data, settings) do
        errors(data, settings) == []
    end

    def validate(data) do
        validate(data, Extract.settings(data))
    end

    def validate(data, settings) do
        case errors(data, settings) do
            errors when errors != [] -> {:error, errors}
            _ -> {:ok, data}
        end
    end

    def errors(data) do
        errors(data, Extract.settings(data))
    end

    def errors(data, settings) do
        Enum.filter(results(data, settings), &match?({:error, _, _, _}, &1))
    end

    def results(data) do
        results(data, Extract.settings(data))
    end

    def results(data, settings) do
        settings
        |> Enum.map(fn {attribute, validations} ->
            validations =
                case is_function(validations) do
                    true -> [by: validations]
                    false -> validations
                end

                Enum.map(validations, fn {name, options} ->
                    result(data, attribute, name, options)
                end)
        end)
        |> List.flatten()
    end

    defp result(data, attribute, name, options) do
        v = validator(name)

        if Validator.validate?(data, options) do
            result = data |> extract(attribute, name) |> v.validate(data, options)

            case result do
                {:error, message} -> {:error, attribute, name, message}
                :ok -> {:ok, attribute, name}
                _ -> raise "'#{name}'' validator should return :ok or {:error, message}"
            end
        else
                {:not_applicable, attribute, name}
        end
    end

    @doc """
    Lookup a validator from configured sources

    ## Examples

    iex> Schema.validator(:presence)
    Schema.Validators.Presence
    iex> Schema.validator(:exclusion)
    Schema.Validators.Exclusion
    """
    def validator(name) do
        case name |> validator(sources()) do
            nil -> raise InvalidValidatorError, validator: name, sources: sources()
            found -> found
        end
    end

    @doc """
    Lookup a validator from given sources

    ## Examples

    iex> Schema.validator(:presence, [[presence: :presence_stub]])
    :presence_stub
    iex> Schema.validator(:exclusion, [Schema.Validators])
    Schema.Validators.Exclusion
    iex> Schema.validator(:presence, [Schema.Validators, [presence: :presence_stub]])
    Schema.Validators.Presence
    iex> Schema.validator(:presence, [[presence: :presence_stub], Schema.Validators])
    :presence_stub
    """
    def validator(name, sources) do
        Enum.find_value(sources, fn source ->
            Source.lookup(source, name)
        end)
    end

    defp sources do
        case Application.get_env(:vex, :sources) do
            nil -> [Schema.Validators]
            sources -> sources
        end
    end

    defp extract(data, attribute, :confirmation) do
        [attribute, String.to_atom("#{attribute}_confirmation")]
        |> Enum.map(fn attr -> Extract.attribute(data, attr) end)
    end

    defp extract(data, attribute, _name) do
        Extract.attribute(data, attribute)
    end
end
