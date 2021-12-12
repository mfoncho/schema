defmodule AbsenceTestRecord do
    defstruct name: nil, identifier: nil
    use Schema.Struct

    validates(:name, absence: true)
end

defmodule AbsenceTest do
    use ExUnit.Case

    test "keyword list, provided absence validation" do
        assert !Schema.valid?([name: "Foo"], name: [absence: true])
        assert Schema.valid?([name: ""], name: [absence: true])
        assert !Schema.valid?([items: [:a]], items: [absence: true])
        assert Schema.valid?([items: []], items: [absence: true])
        assert Schema.valid?([items: {}], items: [absence: true])
        assert Schema.valid?([name: "Foo"], id: [absence: true])
    end

    test "map, provided absence validation" do
        assert !Schema.valid?(%{name: "Foo"}, name: [absence: true])
        assert !Schema.valid?(%{"name" => "Foo"}, %{"name" => [absence: true]})
        assert Schema.valid?(%{name: ""}, name: [absence: true])
        assert !Schema.valid?(%{items: [:a]}, items: [absence: true])
        assert Schema.valid?(%{items: []}, items: [absence: true])
        assert Schema.valid?(%{items: {}}, items: [absence: true])
        assert Schema.valid?(%{name: "Foo"}, id: [absence: true])
        assert Schema.valid?(%{"name" => "Foo"}, name: [absence: true])
    end

    test "keyword list, included absence validation" do
        assert !Schema.valid?(name: "Foo", _vex: [name: [absence: true]])
        assert Schema.valid?(name: "Foo", _vex: [id: [absence: true]])
    end

    test "record, included absence validation" do
        assert !Schema.valid?(%AbsenceTestRecord{name: "I have a name"})
        assert Schema.valid?(%AbsenceTestRecord{name: nil})
        assert Schema.valid?(%AbsenceTestRecord{name: []})
        assert Schema.valid?(%AbsenceTestRecord{name: ""})
        assert Schema.valid?(%AbsenceTestRecord{name: {}})
    end
end
