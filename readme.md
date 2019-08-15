
Authorization mod for minetest
=================


To be used with https://github.com/thomasrudin-mt/auth_proxy_app

# Overview

Lets third-party apps query username and password of ingame players

# Installing

* Copy/Clone the files into the `worldmods` folder
* Install and start https://github.com/thomasrudin-mt/auth_proxy_app

## minetest.conf

Example usage:
```
secure.http_mods = auth_proxy_mod
auth_proxy.url = http://127.0.0.1:8080
```
