---eye_height = 1.625,

minetest.register_globalstep(function(dtime)
 for _,player in ipairs(minetest.get_connected_players()) do
   if player:get_player_control().sneak == true then
     player:set_eye_offset({x=0,y=-2,z=0},{x=0,y=-2,z=0})
   else
     player:set_eye_offset({x=0,y=0,z=0},{x=0,y=0,z=0})
   end
 end
end)
