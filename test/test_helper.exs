defmodule RecordTest do
    use Schema.Struct
    defstruct name: nil, identifier: nil

    validates(:name, presence: true)
end

defmodule UserTest do
    use Schema.Struct
    defstruct username: nil, password: nil, password_confirmation: nil, age: nil

    validates(:username, presence: true, length: [min: 4], format: ~r/(^[[:alpha:]][[:alnum:]]+$)/)
    validates(:password, length: [min: 4], confirmation: true)
end

defmodule TestValidatorSourceByStructure.Criteria do
    def validate(_value, _options) do
    end
end

defmodule TestValidatorSourceByFunctionResult do
    def validate(_value, _options) do
    end
end

defmodule TestValidatorSourceByFunction do
    def validator(_name) do
    # always; stub
        TestValidatorSourceByFunctionResult
    end
end

defmodule TestValidatorSourceByFunction.Criteria do
  # Should be ignored
end

ExUnit.start()
