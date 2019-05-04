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
    end
	end,
})
