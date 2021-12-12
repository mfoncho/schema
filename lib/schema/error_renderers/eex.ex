defmodule Schema.ErrorRenderers.EEx do
    @moduledoc false

    @behaviour Schema.ErrorRenderer

    @doc """
    ## Examples

        iex> Schema.ErrorRenderers.EEx.message(nil, "default")
        "default"

        iex> Schema.ErrorRenderers.EEx.message([message: "override"], "default")
        "override"

        iex> Schema.ErrorRenderers.EEx.message([message: "Context #<%= value %>"], "default", value: 2)
        "Context #2"

    """
    def message(options, default, context \\ []) do
        message = Schema.ErrorRenderer.get_message(options, default)
        message |> EEx.eval_string(context)
    end
end
