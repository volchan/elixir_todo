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
      |> CSV.decode
      |> Enum.take(2)
  end

  defp format(input) do
    format_todos = fn (el, acc) ->
      [id, task, date, status] = elem(el, 1)
      id = id |> String.to_integer
      Map.put(acc, id, %Todo{id: id, task: task, date: date, status: status})
    end

    todos = Enum.reduce(input, %{}, format_todos)
    last_id = Map.keys(todos) |> Enum.max

    %ElixirTodo{last_id: last_id, todos: todos}
  end

  defp display_list(todos) do
    "----- Todo List -----" |> IO.puts
    todos.todos |> Enum.each(
      fn (todo) ->
        todo_struct = elem(todo, 1)
        "#{todo_struct.id} -> " <>
          "#{todo_struct.date} - " <>
          "#{todo_struct.task} - " <>
          "#{Todo.display_todo_status(todo_struct)}"
          |> IO.puts
      end
    )
    "---------------------" |> IO.puts
    display_menu(todos)
  end

  defp write_csv(todos) do
    file = File.open!(@path, [:write, :utf8])
    todos |> CSV.encode |> Enum.each(&IO.write(file, &1))
  end

  defp add_task(todos) do
    id = todos.last_id + 1
    task = "What if your task ? " |> IO.gets |> String.trim
    date = "When is your task due ? " |> IO.gets |> String.trim
    new_todos = %ElixirTodo{
      last_id: id,
      todos: Map.put_new(todos.todos, id, %Todo{date: date, id: id, status: "false", task: task})
    }
    write_csv(new_todos.todos)
    display_list(new_todos)
  end

  defp dispatch(todos) do
    user_choise = "What do you want to do ? " |> IO.gets |> String.trim
    cond do
      user_choise == "1" -> display_list(todos)
      user_choise == "2" -> add_task(todos)
      # user_choise == "3" -> update_task(todos)
      # user_choise == "4" -> delete_task(todos)
      user_choise == "5" -> exit(:shutdown)
      true -> dispatch(todos)
    end
  end

  defp display_menu(todos) do
    "1 -> Show todo list." |> IO.puts
    "2 -> Add a new task." |> IO.puts
    "3 -> Change task status." |> IO.puts
    "4 -> Delete a task." |> IO.puts
    "5 -> Exit !" |> IO.puts
    dispatch(todos)
  end

  def run do
    todos = init()
    display_menu(todos)
  end
end
