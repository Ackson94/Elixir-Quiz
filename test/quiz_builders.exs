defmodule QuizBuilders do
  defmacro __using__(options) do
    quote do
      alias Mastery.Core.{Template, Response, Quiz}
      import QuizBuilders, only: :function
    end
  end

  def template_fields(overrides \\ []) do
    Keyword.merge(
      [
        name: :single_digit_addition,
        category: :addition,
        instructions: "Addition the numbers",
        raw: "<%= @left %> + <%= @right %>",
        generators: addition_generators(single_digit()),
        checker: &addition_checker/2
      ],
      overrides
    )
  end
end
