defmodule Sum do
  # Calculate the sum of items in a list
  def sum_list([head|tail], acc) do
    sum_list(tail, acc + head)
  end
  
  def sum_list([], acc) do
    acc
  end  
end
