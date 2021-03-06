defmodule Schema.Struct do
    @moduledoc false

    defmacro __using__(_) do
        quote do
            @vex_validations %{}
            @before_compile unquote(__MODULE__)
            import unquote(__MODULE__)
            def valid?(self), do: Schema.valid?(self)
        end
    end

    defmacro __before_compile__(_) do
        quote do
            def __vex_validations__(), do: @vex_validations

            require Schema.Extract.Struct
            Schema.Extract.Struct.for_struct()
        end
    end

    defmacro validates(name, validations \\ []) do
        quote do
            @vex_validations Map.put(@vex_validations, unquote(name), unquote(validations))
        end
    end
end
