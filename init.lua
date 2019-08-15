auth_proxy = {
  disallow_banned_players = true,
  url = minetest.settings:get("auth_proxy.url"),
  tan = {}
}


local MP = minetest.get_modpath(minetest.get_current_modname())
dofile(MP .. "/auth.lua")
dofile(MP .. "/tan.lua")

local http = minetest.request_http_api()
if not http then
  minetest.log("error", "auth_proxy_mod mod not in the secure.http_mods setting!")
  return
end

auth_proxy.http_init(http, auth_proxy.url)
