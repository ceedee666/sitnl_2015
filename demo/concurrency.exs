

defmodule Router do
  def route do
    receive do
      {[ first | tail ], msg} -> 
        #IO.puts "#{inspect self} received: #{msg}!"
        #IO.puts "routing to next #{inspect first}"
        send(first, {tail, msg})
        
      {[], msg } -> 
        IO.puts "#{inspect self} Huuray, Got the delivery: #{msg}!"
    end
  end
end

defmodule Messenger do
  def deliver(message, processes) do
		[router|routers] = Enum.map(1..processes, fn(_) -> spawn(Router, :route, []) end)

    send(router, {routers , message})
  end
end
