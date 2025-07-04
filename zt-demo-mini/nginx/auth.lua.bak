local jwt = require "resty.jwt"
local http = require "resty.http"
local cjson = require "cjson"

local token = ngx.req.get_headers()["Authorization"]
if not token or not token:find("Bearer ") then
  ngx.status = 401
  ngx.say("Missing or invalid Authorization header")
  return ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

token = token:gsub("Bearer ", "")

local jwt_obj = jwt:verify("secret123", token)

if not jwt_obj.verified then
  ngx.status = 401
  ngx.say("Invalid token: ", jwt_obj.reason)
  return ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

local user = jwt_obj.payload.sub
local role = jwt_obj.payload.role

local httpc = http.new()
local method = ngx.req.get_method()
local res, err = httpc:request_uri("http://opa:8181/v1/data/httpapi/authz/allow", {
  method = "POST",
  body = cjson.encode({
    input = {
      user = user,
      role = role,
      path = { "data" },
      method = method
    }
  }),
  headers = { ["Content-Type"] = "application/json" }
})

local result = cjson.decode(res.body)
if result.result ~= true then
  ngx.status = 403
  ngx.say("Access Denied")
  return ngx.exit(ngx.HTTP_FORBIDDEN)
end
