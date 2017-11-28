defmodule Todo do
  defstruct [:id, :task, :date, :status]
  # equivalent of defstruct id: nil, task: nil, date: nil, status: nil
  def display_todo_status(todo) do
    cond do
      todo.status == "true" -> "[X]"
      todo.status == "false" -> "[ ]"
    end
  end
end
