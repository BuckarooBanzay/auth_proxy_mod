
local MP = minetest.get_modpath(minetest.get_current_modname())
local Channel = dofile(MP .. "/util/channel.lua")
local channel

local has_xban2_mod = minetest.get_modpath("xban2")

-- auth request
local function auth_handler(auth)
	local handler = minetest.get_auth_handler()
	minetest.log("action", "[auth_proxy] auth: " .. auth.username)

	local success = false
	local banned = false
	local message = ""

	local custom_auth_success, custom_msg = auth_proxy.custom_handler(auth.username)
	if not custom_auth_success and custom_msg then
		message = custom_msg
	end

	if auth_proxy.disallow_banned_players and has_xban2_mod then
		-- check xban db
		local xbanentry = xban.find_entry(auth.username)
		if xbanentry and xbanentry.banned then
			banned = true
			message = "Banned!"
		end
	end

	if not banned and custom_auth_success then
		-- check tan
		local tan = auth_proxy.tan[auth.username]
		if tan ~= nil then
			success = tan == auth.password
		end

		-- check auth
		if not success then
			local entry = handler.get_auth(auth.username)
			if entry and minetest.check_password_entry(auth.username, entry.password, auth.password) then
				success = true
			end
		end
	end

	channel.send({
		name = auth.username,
		success = success,
		message = message
	})
end


function auth_proxy.http_init(http, url)
	channel = Channel(http, url .. "/api/minetest/channel")
	channel.receive(auth_handler)
end
