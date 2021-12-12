defmodule DocTest do
    use ExUnit.Case
    # Main
    doctest Schema
    doctest Schema.Validator
    # Validator Utilities
    doctest Schema.Validator.ErrorMessage
    doctest Schema.Validator.Skipping
    # Built-in Validators
    doctest Schema.Validators.Absence
    doctest Schema.Validators.Acceptance
    doctest Schema.Validators.By
    doctest Schema.Validators.Confirmation
    doctest Schema.Validators.Exclusion
    doctest Schema.Validators.Format
    doctest Schema.Validators.Inclusion
    doctest Schema.Validators.Length
    doctest Schema.Validators.Number
    doctest Schema.Validators.Presence
    doctest Schema.Validators.Uuid
    # Built-in ErrorRenderers
    doctest Schema.ErrorRenderers.EEx
    doctest Schema.ErrorRenderers.Parameterized
end
