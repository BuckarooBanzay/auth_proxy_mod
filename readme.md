
Authorization mod for minetest
=================


To be used with https://github.com/minetest-auth-proxy/auth_proxy_app

# Overview

Lets third-party apps query username and password of ingame players

# Installing

* Copy/Clone the files into the `worldmods` folder
* Install and start https://github.com/minetest-auth-proxy/auth_proxy_app

# compatibility

If `xban2` is available, the `banned` flag on the xban-database is additionally
checked on login

# API

## Custom auth handler

Additional checks besides the user/password can be implemented with a custom handler function

**Example**: require a priv to login:
```lua
auth_proxy.custom_handler = function(name)
  if minetest.check_player_privs(name, "mypriv") then
    return true
  else
    return false, "Missing priv: 'mypriv'"
  end
end
```

## minetest.conf

Example usage:
```
secure.http_mods = auth_proxy_mod
auth_proxy.url = http://127.0.0.1:8080
```
