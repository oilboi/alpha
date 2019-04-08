minetest.register_chatcommand("suicide", {
	params = "<text>",
	description = "Commit suicide",
	privs = {},
	func = function( name , text)
    minetest.get_player_by_name(name):set_hp(-5)
		minetest.chat_send_all(name.." ended it.")
	end,
})

minetest.register_chatcommand("s", {
	params = "<text>",
	description = "Commit suicide",
	privs = {},
	func = function( name , text)
    minetest.get_player_by_name(name):set_hp(-5)
		minetest.chat_send_all(name.." ended it.")
	end,
})
