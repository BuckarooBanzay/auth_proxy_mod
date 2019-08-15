
local MP = minetest.get_modpath(minetest.get_current_modname())
local Channel = dofile(MP .. "/util/channel.lua")
local channel

local has_xban2_mod = minetest.get_modpath("xban2")

-- auth request
local function auth_handler(auth)
	local handler = minetest.get_auth_handler()
	minetest.log("action", "[auth_proxy] auth: " .. auth.name)

	local success = false
	local banned = false
	local message = ""

	if auth_proxy.disallow_banned_players and has_xban2_mod then
		-- check xban db
		local xbanentry = xban.find_entry(auth.name)
		if xbanentry and xbanentry.banned then
			banned = true
			message = "Banned!"
		end
	end

	if not banned then
		-- check tan
		local tan = auth_proxy.tan[auth.name]
		if tan ~= nil then
			success = tan == auth.password
		end

		-- check auth
		if not success then
			local entry = handler.get_auth(auth.name)
			if entry and minetest.check_password_entry(auth.name, entry.password, auth.password) then
				success = true
			end
		end
	end

	channel.send({
		type = "auth",
		data = {
			name = auth.name,
			success = success,
			message = message
		}
	})
end


function auth_proxy.http_init(http, url)
	channel = Channel(http, url .. "/api/minetest/channel")

	channel.receive(function(data)
		if data.type == "auth" then
			auth_handler(data.data)
		end
	end)
end
