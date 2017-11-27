defmodule ElixirTodo do
  @moduledoc """
  Todo list application to work with .csv files through IEx.
  """

  @path_env %{dev: ["lib", "db", "todos.csv"], test: ["lib", "db", "todos_test.csv"]}
  @path Path.join(@path_env[Mix.env])

  defstruct last_id: 0, todos: %{}

  def init do
    @path
      |> read_file!
      |> format
  end

  defp read_file!(path) do
    path
      |> File.stream!
      |> Stream.map(&String.replace(&1, "\n", ""))
  end

  defp format(input) do
    format_todos = fn (el, acc) ->
      [id, task, date, status] = String.split(el, ",")
      id = id |> String.to_integer

      Map.put(acc, id, %Todo{id: id, task: task, date: date, status: status})
    end

    todos = Enum.reduce(input, %{}, format_todos)
    last_id = Map.keys(todos) |> Enum.max

    %ElixirTodo{last_id: last_id, todos: todos}
  end
end
