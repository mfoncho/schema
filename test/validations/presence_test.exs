defmodule PresenceTest do
    use ExUnit.Case

    test "keyword list, provided presence validation" do
        assert Schema.valid?([name: "Foo"], name: [presence: true])
        assert !Schema.valid?([name: ""], name: [presence: true])
        assert Schema.valid?([items: [:a]], items: [presence: true])
        assert !Schema.valid?([items: []], items: [presence: true])
        assert !Schema.valid?([items: {}], items: [presence: true])
        assert !Schema.valid?([name: "Foo"], id: [presence: true])
        assert Schema.valid?([total: 0.0], total: [presence: true])
        assert Schema.valid?([total: 1.0], total: [presence: true])
        assert Schema.valid?([total: 0], total: [presence: true])
        assert Schema.valid?([total: 1], total: [presence: true])
        assert Schema.valid?([date: Date.utc_today()], date: [presence: true])
        assert Schema.valid?([date: NaiveDateTime.utc_now()], date: [presence: true])
        assert Schema.valid?([date: DateTime.utc_now()], date: [presence: true])
        assert Schema.valid?([date: Time.utc_now()], date: [presence: true])
        refute Schema.valid?([date: nil], date: [presence: true])
    end

    test "map, provided presence validation" do
        assert Schema.valid?([name: "Foo"], name: [presence: true])
        assert !Schema.valid?(%{name: "Foo"}, id: [presence: true])
        assert Schema.valid?(%{"name" => "Foo"}, %{"name" => [presence: true]})

        assert Schema.valid?(%{"name" => "Foo", "age" => 21}, %{
            "name" => [presence: true],
            "age" => [presence: true]
        })

        assert !Schema.valid?(%{"name" => "Foo"}, %{
            "name" => [presence: true],
            "age" => [presence: true]
        })

        assert !Schema.valid?(%{"name" => "Foo"}, %{"id" => [presence: true]})
        assert !Schema.valid?(%{"name" => "Foo"}, name: [presence: true])
        assert Schema.valid?(%{"date" => Date.utc_today()}, %{"date" => [presence: true]})
        assert Schema.valid?(%{"date" => DateTime.utc_now()}, %{"date" => [presence: true]})
        assert Schema.valid?(%{"date" => NaiveDateTime.utc_now()}, %{"date" => [presence: true]})
        assert Schema.valid?(%{"date" => Time.utc_now()}, %{"date" => [presence: true]})
        refute Schema.valid?(%{"date" => nil}, %{"date" => [presence: true]})
    end

    test "keyword list, included presence validation" do
        assert Schema.valid?(name: "Foo", _vex: [name: [presence: true]])
        assert !Schema.valid?(name: "Foo", _vex: [id: [presence: true]])
    end

    test "record, included presence validation" do
        assert Schema.valid?(%RecordTest{name: "I have a name"})
    end
end
