# Agenda

1. [Why functional programming?](#/2)
1. [Why elixir?](#/3)
1. [Basic types & Operators](#/4)
1. [Pattern matching](#/5)
1. [Functions](#/6)
1. [Recursion](#/7)
1. [Concurrency](#/8)



# Why FP?

- Abstractions
- Immutability
- DSLs
- Concurrency



#Why elixir?

- Runs on the Erlang VM
  - Reuse Erlang libraries
  - Modern functional language

- Erlang VM
  - Scalable 
  - Fault-Tolerant 
  - Simplified concurrent programming 



#Basic Types & Operators


## Basic Types

``` Elixir
# There are numbers
3    # integer
3.0  # float

# Atoms, that are literals, a constant with name.
:hello # atom

# Strings
"hello" # string

# Lists that are implemented as linked lists.
[1,2,3] # list

# Tuples that are stored contiguously in memory.
{:ok,"hello",1} # tuple

# Maps
%{:first_name => "Christian", :last_name => "Drumm"}
```


## Operators

``` Elixir
# Arithmetic operators
1 + 1
2 * 5
10 / 3
div(10, 3)

# List operators
[1,2,3] ++ [4,5,6]
[1,2,3] -- [2]

# Boolean operators
true and true
false or is_atom(:hello)
```



#Pattern matching


## The match operator

`=` is called the *match operator*

``` Elixir
# not simply an assignment
x = 1

# one match succeeds the other fails 
1 = x
2 = x
```


##Pattern matching

``` Elixir
# a complex match
{a, b, c} = {:hello, "world", 42}

# this match fails
{a, b, c} = {:hello, "world"}

# matching for specific values
{:ok, result} = {:ok, 13}

# mathing with lists
[head | tail] = [1, 2, 3]
[h|_] = [3, 4, 5]

```



#Functions
 
* Two types of functions
  * Anonymous functions
  * Named functions

* Functions are first-class citizens 
  * Can be assigned to variables
  * Can be function parameters
  * Can be return value of other functions


##Anonymous & named functions

``` Elixir
# Anonymous functions
d = &(&1 + &1)
s = fn(x) -> x * x end

# Named function
# Note that function params are patterns
defmodule SitMuc1 do
  def factorial(0) do 1 end
  def factorial(n) do n * factorial(n-1) end
end
```


##Higher order functions

``` Elixir
# Create a list with some data 
user1 = %{:first_name => "Christian", :last_name => "Drumm"}
user2 = %{:first_name => "Martin", :last_name => "Steinberg"}
user3 = %{:first_name => "Gregor", :last_name => "Wolf"}
users = [user1, user2, user3]

# Function that fetches an entry from a map
get_element = fn(key_word) ->
  fn(user) ->
    user[key_word]
  end
end

# Apply the function to the list
Enum.map(users, get_element.(:first_name))
Enum.map(users, get_element.(:last_name))
```



#Recursion


## Recursion vs. Loops

* Due to immutability loops are expressed as recursion
* Example sum the items in a list*

``` Elixir
defmodule Sum
  # Calculate the sum of items in a list
  def sum_list([head|tail], acc) do
    sum_list(tail, acc + head)
  end
  
  def sum_list([], acc) do
    acc
  end  
end
```

*Usually this should be implemente using [Enum.reduce/2](http://elixir-lang.org/docs/v1.0/elixir/Enum.html#reduce/2)


## Tail call optimization

* Fibonacci sequence
  * F(0) = 0
  * F(1) = 1
  * F(n) = F(n-1) + F(n-2)
* Alternative definition
  > Fibonacci - A problem used to teach recursion in computer science


``` Elixir
defmodule NaiveFib do 
  def fib(0) do 0 end
  def fib(1) do 1 end
  
  def fib(n) do 
    fib(n-1) + fib(n-2) 
  end
end
```


``` Elixir
defmodule Fib do
  def fib(n) when is_integer(n) and n >= 0 do
    fibn(n, 1, 0)
  end

  defp fibn(0, _, result) do
    result
  end
  
  defp fibn(n, next, result) do 
    fibn(n-1, next + result, next) 
  end
end
``` 



#Concurrency 

``` Elixir
defmodule Router do
  def route do
    receive do
      {[ first | tail ], msg} -> 
        #IO.puts "#{inspect self} received: #{msg}!"
        #IO.puts "routing to next #{inspect first}"
        send first, {tail, msg}
        route

      {[], msg } -> 
        IO.puts "#{inspect self} Huuray, Got the delivery: #{msg}!"
    end
  end
end
```


``` Elixir
defmodule Messenger do
  def deliver(message, processes) do
    [router|routers] = Enum.map(1..processes, fn(_) -> spawn(Router, :route, []) end)

    send(router, {routers , message})
  end
end
```
