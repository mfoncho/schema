defmodule ByTest do
    use ExUnit.Case

    test "keyword list, provided function validation" do
        assert Schema.valid?([component: "x1234"], component: &(&1 == "x1234"))
        assert !Schema.valid?([component: "x1234"], component: fn c -> c == "z1234" end)
        assert Schema.valid?([component: "x1234"], component: fn c -> byte_size(c) > 4 end)
        assert Schema.valid?([component: "x1234"], component: &(&1 != "BADCOMPONENT"))
        assert Schema.valid?([component: "x1234"], component: [by: fn x -> x == "x1234" end])
    end

    test "keyword list, ok/error tuple return values" do
        x1234_match = fn
            "x1234" -> :ok
            _ -> {:error, :bad_param}
        end

        assert Schema.valid?([component: "x1234"], component: x1234_match)
        assert !Schema.valid?([component: "z1234"], component: x1234_match)

        assert [{:error, :component, :by, :bad_param}] ==
            Schema.errors([component: "z1234"], component: x1234_match)
    end

    test "context dependent validations" do
        x1234_match = fn
            "x1234", [component: _, validate: true] -> :ok
            _, _ -> {:error, :bad_param}
        end

        assert Schema.valid?([component: "x1234", validate: true], component: x1234_match)
        assert !Schema.valid?([component: "z1234", validate: false], component: x1234_match)

        assert [{:error, :component, :by, :bad_param}] ==
            Schema.errors([component: "x1234", validate: false], component: x1234_match)
    end
end
