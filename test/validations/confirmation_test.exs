defmodule ConfirmationTest do
    use ExUnit.Case

    test "keyword list, provided confirmation validation" do
        assert Schema.valid?([password: "1234", password_confirmation: "1234"],
            password: [confirmation: true]
        )

        assert !Schema.valid?([password: "1234"], password: [confirmation: true])

        assert !Schema.valid?([password: "1234", password_confirmation: "1235"],
            password: [confirmation: true]
        )
    end
end
