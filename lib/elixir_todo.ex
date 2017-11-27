defmodule ElixirTodo do
  @moduledoc """
  Todo list application to work with .csv files through IEx.
  """

  @path_env %{dev: ["lib", "db", "todos.csv"], test: ["lib", "db", "todos_test.csv"]}
  @path Path.join(@path_env[Mix.env])

  defstruct last_id: 0, todos: %{}

  @doc """
  Read the .csv file and return its content formatted
  ## Examples
      iex> ElixirTodo.init
      %ElixirTodo{
        last_id: 1,
        todos: %{
          1 => %Todo{
            id: 1,
            task: "Study Erlang",
            date: "2018-01-01",
            status: "todo"
          }
        }
      }
  """

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

  def run do
    todos = init()
    dispatch(todos)
  end

  defp dispatch(todos) do
    "What do you want to do ?"
      |> String.strip
      |> IO.gets 
  end
end
