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
