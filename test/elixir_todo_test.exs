defmodule ElixirTodoTest do
  use ExUnit.Case
  doctest ElixirTodo

  test "if the app will load the data from the csv file correctly" do
    assert ElixirTodo.init == %ElixirTodo{
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
  end
end
