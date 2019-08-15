

minetest.register_chatcommand("wiki_tan", {
	description = "generates a tan (temporary access number) for the wiki access",
	func = function(name)
    local tan = "" .. math.random(1000, 9999)
    auth_proxy.tan[name] = tan

		return true, "Your tan is " .. tan .. ", it will expire upon leaving the game"
	end
})

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	auth_proxy.tan[name] = nil
end)
