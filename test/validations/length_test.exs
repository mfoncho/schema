defmodule LengthTest do
    use ExUnit.Case

    test "keyword list, provided length validation with min and string" do
        assert Schema.valid?([component: "x1234"], component: [length: [min: 1]])
        assert Schema.valid?([component: "x1234"], component: [length: [min: 5]])
        assert !Schema.valid?([component: "x1234"], component: [length: [min: 6]])
    end

    test "keyword list, provided length validation with min and list" do
        assert Schema.valid?([component: [1, 2, 3, 4, 5]], component: [length: [min: 1]])
        assert Schema.valid?([component: [1, 2, 3, 4, 5]], component: [length: [min: 5]])
        assert !Schema.valid?([component: [1, 2, 3, 4, 5]], component: [length: [min: 6]])
    end

    test "keyword list, provided length validation with max and string" do
        assert Schema.valid?([component: "x1234"], component: [length: [max: 10]])
        assert Schema.valid?([component: "x1234"], component: [length: [max: 5]])
        assert !Schema.valid?([component: "x1234"], component: [length: [max: 1]])
    end

    test "keyword list, provided length validation with max and string and tokenizer" do
        assert Schema.valid?([words: "a b c d e"], words: [length: [max: 10, tokenizer: &String.split/1]])

        assert Schema.valid?([words: "a b c d e"], words: [length: [max: 5, tokenizer: &String.split/1]])

        assert !Schema.valid?([words: "a b c d e"], words: [length: [max: 1, tokenizer: &String.split/1]])
    end

    test "keyword list, provided length validation with max and list" do
        assert Schema.valid?([component: [1, 2, 3, 4, 5]], component: [length: [max: 10]])
        assert Schema.valid?([component: [1, 2, 3, 4, 5]], component: [length: [max: 5]])
        assert !Schema.valid?([component: [1, 2, 3, 4, 5]], component: [length: [max: 1]])
    end

    test "keyword list, provided length validation with in as range" do
        assert Schema.valid?([component: "x1234"], component: [length: [in: 0..8]])
        assert Schema.valid?([component: "x1234"], component: [length: [in: 0..5]])
        assert !Schema.valid?([component: "x1234"], component: [length: [in: 0..3]])
    end
end
