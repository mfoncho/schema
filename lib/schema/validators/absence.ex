defmodule Schema.Validators.Absence do
    @moduledoc """
    Ensure a value is absent.

    Schema uses the `Schema.Blank` protocol to determine "absence."
    Notably, empty strings and collections are considered absent.

    ## Options

    * `:message`: Optional. A custom error message. May be in EEx format
      and use the fields described in "Custom Error Messages," below.

    ## Examples

    iex> Schema.Validators.Absence.validate(1, true)
    {:error, "must be absent"}
    iex> Schema.Validators.Absence.validate(nil, true)
    :ok
    iex> Schema.Validators.Absence.validate(false, true)
    :ok
    iex> Schema.Validators.Absence.validate("", true)
    :ok
    iex> Schema.Validators.Absence.validate([], true)
    :ok
    iex> Schema.Validators.Absence.validate([], true)
    :ok
    iex> Schema.Validators.Absence.validate([1], true)
    {:error, "must be absent"}
    iex> Schema.Validators.Absence.validate({1}, true)
    {:error, "must be absent"}

    ## Custom Error Messages

    Custom error messages (in EEx format), provided as :message, can use the following values:

    iex> Schema.Validators.Absence.__validator__(:message_fields)
    [value: "The bad value"]

    An example:

    iex> Schema.Validators.Absence.validate([1], message: "can't be <%= inspect value %>")
    {:error, "can't be [1]"}
    """
    use Schema.Validator

    @message_fields [value: "The bad value"]
    def validate(value, options) do
        if Schema.Blank.blank?(value) do
          :ok
        else
            {:error, message(options, "must be absent", value: value)}
        end
    end
end
