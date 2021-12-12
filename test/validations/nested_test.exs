defmodule NestedTestRecord do
    defstruct author: nil
    use Schema.Struct

    validates([:author, :name], presence: true)
end

defmodule NestedTest do
    use ExUnit.Case

    test "nested" do
        assert Schema.valid?([author: [name: "Foo"]], %{[:author, :name] => [presence: true]})

        nested_errors = [{:error, [:author, :name], :presence, "must be present"}]

        assert nested_errors ==
            Schema.errors([author: [name: ""]], %{[:author, :name] => [presence: true]})
    end

    test "nested with _vex" do
        assert Schema.valid?(author: [name: "Foo"], _vex: %{[:author, :name] => [presence: true]})

        nested_errors = [{:error, [:author, :name], :presence, "must be present"}]

        assert nested_errors ==
            Schema.errors(author: [name: ""], _vex: %{[:author, :name] => [presence: true]})
    end

    test "nested in Record" do
        assert Schema.valid?(%NestedTestRecord{author: [name: "Foo"]})

        nested_errors = [{:error, [:author, :name], :presence, "must be present"}]
        assert nested_errors == Schema.errors(%NestedTestRecord{author: [name: ""]})
    end
end
