defmodule Schema.ErrorRenderers.Parameterized do
    @moduledoc false

    @behaviour Schema.ErrorRenderer

    @doc """

    ## Examples

        iex> Schema.ErrorRenderers.Parameterized.message(nil, "default")
        [message: "default", context: []]

        iex> Schema.ErrorRenderers.Parameterized.message([message: "override"], "default")
        [message: "override", context: []]

        iex> Schema.ErrorRenderers.Parameterized.message([message: "Context #<%= value %>"], "default", value: 2)
        [message: "Context #<%= value %>", context: [value: 2]]

    """
    def message(options, default, context \\ []) do
        message = Schema.ErrorRenderer.get_message(options, default)
        [message: message, context: context]
    end
end
