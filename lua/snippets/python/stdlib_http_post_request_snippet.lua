local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "stdlib_http_post_request",
      t([[
import http.client, urllib
conn = http.client.HTTPSConnection("api.pushover.net:443")
conn.request("POST", "/1/messages.json",
    urllib.parse.urlencode({
        "token": "abc123",
        "user": "user123",
        "message": "hello world",
    }), { "Content-type": "application/x-www-form-urlencoded" })
conn.getresponse()
]])
    ),
  },
}

return snippet
