defmodule SchemaTest do
    use ExUnit.Case

    test "invalid validation name error is raised" do
        assert_raise Schema.InvalidValidatorError, fn ->
            Schema.valid?([name: "Foo"], name: [foobar: true])
        end
    end

    test "keyword list, provided multiple validations" do
        assert Schema.valid?([name: "Foo"],
            name: [presence: true, length: [min: 2, max: 10], format: ~r(^Fo.$)]
        )
    end

    test "record, included complex validation" do
        user = %UserTest{
            username: "actualuser",
            password: "abcdefghi",
            password_confirmation: "abcdefghi"
        }

        assert Schema.valid?(user)
        assert Schema.results(user) != []
        assert Schema.errors(user) == []
        assert UserTest.valid?(user)
    end

    test "keyword list, included complex validation" do
        user = [
            username: "actualuser",
            password: "abcdefghi",
            password_confirmation: "abcdefghi",
            _vex: [
                username: [presence: true, length: [min: 4], format: ~r(^[[:alpha:]][[:alnum:]]+$)],
                password: [length: [min: 4], confirmation: true]
            ]
        ]

        assert Schema.valid?(user)
        assert length(Schema.results(user)) > 0
        assert Schema.errors(user) == []
    end

    test "keyword list, included complex validation with errors" do
        user = [
            username: "actualuser",
            password: "abc",
            password_confirmation: "abcdefghi",
            _vex: [
                username: [presence: true, length: [min: 4], format: ~r(^[[:alpha:]][[:alnum:]]+$)],
                password: [length: [min: 4], confirmation: true]
            ]
        ]

        assert !Schema.valid?(user)
        assert length(Schema.results(user)) > 0
        assert length(Schema.errors(user)) == 2
    end

    test "keyword list, included complex validation with non-applicable validations" do
        user = [
            username: "actualuser",
            password: "abcd",
            password_confirmation: "abcdefghi",
            state: :persisted,
            _vex: [
                username: [presence: true, length: [min: 4], format: ~r(^[[:alpha:]][[:alnum:]]+$)],
                password: [length: [min: 4, if: [state: :new]], confirmation: [if: [state: :new]]]
                ]
                ]

                assert Schema.valid?(user)
                end

            test "validate returns {:ok, data} on success" do
            assert {:ok, [name: "Foo"]} =
                Schema.validate([name: "Foo"], name: [length: [min: 2, max: 10], format: ~r(^Fo.$)])
            end

            test "validate returns {:error, errors} on error" do
                assert {:error, [{:error, :name, :length, "must have a length of at least 4"}]} =
                    Schema.validate([name: "Foo"], name: [length: [min: 4]])
            end

            test "validator lookup by structure" do
                validator = Schema.validator(:criteria, [TestValidatorSourceByStructure])
                assert validator == TestValidatorSourceByStructure.Criteria
            end

            test "validator lookup by function" do
                validator = Schema.validator(:criteria, [TestValidatorSourceByFunction])
                assert validator == TestValidatorSourceByFunctionResult
            end
end
