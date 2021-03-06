defmodule AcceptanceTestRecord do
    defstruct accepts_terms: false
    use Schema.Struct

    validates(:accepts_terms, acceptance: true)
end

defmodule CustomAcceptanceTestRecord do
    defstruct accepts_terms: false
    use Schema.Struct

    validates(:accepts_terms, acceptance: [as: "yes"])
end

defmodule AcceptanceTest do
    use ExUnit.Case

    test "keyword list, provided basic acceptance validation" do
        assert Schema.valid?([accepts_terms: true], accepts_terms: [acceptance: true])
        assert Schema.valid?([accepts_terms: "anything"], accepts_terms: [acceptance: true])
        assert !Schema.valid?([accepts_terms: nil], accepts_terms: [acceptance: true])
    end

    test "keyword list, included presence validation" do
        assert Schema.valid?(accepts_terms: true, _vex: [accepts_terms: [acceptance: true]])
        assert Schema.valid?(accepts_terms: "anything", _vex: [accepts_terms: [acceptance: true]])
        assert !Schema.valid?(accepts_terms: false, _vex: [accepts_terms: [acceptance: true]])
    end

    test "keyword list, provided custom acceptance validation" do
        assert Schema.valid?([accepts_terms: "yes"], accepts_terms: [acceptance: [as: "yes"]])
        assert !Schema.valid?([accepts_terms: false], accepts_terms: [acceptance: [as: "yes"]])
        assert !Schema.valid?([accepts_terms: true], accepts_terms: [acceptance: [as: "yes"]])
    end

    test "keyword list, included custom validation" do
        assert Schema.valid?(accepts_terms: "yes", _vex: [accepts_terms: [acceptance: [as: "yes"]]])
        assert !Schema.valid?(accepts_terms: false, _vex: [accepts_terms: [acceptance: [as: "yes"]]])
        assert !Schema.valid?(accepts_terms: true, _vex: [accepts_terms: [acceptance: [as: "yes"]]])
    end

    test "record, included basic presence validation" do
        assert Schema.valid?(%AcceptanceTestRecord{accepts_terms: "yes"})
        assert Schema.valid?(%AcceptanceTestRecord{accepts_terms: true})
    end

    test "record, included custom presence validation" do
        assert Schema.valid?(%CustomAcceptanceTestRecord{accepts_terms: "yes"})
        assert !Schema.valid?(%CustomAcceptanceTestRecord{accepts_terms: true})
        assert !Schema.valid?(%CustomAcceptanceTestRecord{accepts_terms: false})
    end
end
