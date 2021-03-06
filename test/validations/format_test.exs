defmodule FormatTest do
    use ExUnit.Case

    test "keyword list, provided format validation" do
        assert Schema.valid?([component: "x1234"], component: [format: [with: ~r/(^x\d+$)/]])
        assert !Schema.valid?([component: "d1234"], component: [format: [with: ~r/(^x\d+$)/]])
        assert !Schema.valid?([component: nil], component: [format: [with: ~r/(^x\d+$)/]])
    end

    test "custom error messages" do
        assert Schema.errors([component: "will not match"],
                component: [format: [with: ~r/foo/, message: "Custom!"]]
            ) == [{:error, :component, :format, "Custom!"}]
    
        assert Schema.errors([component: "will not match"],
                component: [
                format: [
                    with: ~r/foo/,
                    message: "'<%= value %>' doesn't match <%= inspect pattern %>"
                ]
                ]
            ) == [{:error, :component, :format, "'will not match' doesn't match ~r/foo/"}]
    end

end
