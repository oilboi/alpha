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

minetest.register_chatcommand("weather", {
	params = "Weather type",
	description = "0 clear, 1 rain, 2 snow.",
	privs = {server = true},
	func = function( name, param)
    local tab = {"clear","rain","snow"}
    local newweather = tonumber(param)
		if newweather >= 0 and newweather <= 2 then
      minetest.chat_send_all("Admin "..name.." has changed the weather to "..tab[newweather+1]..".")
      weather = newweather
      weather_change_goal = math.random(200,400)

			delete_weather_particle_spawners()
    end
	end,
})
