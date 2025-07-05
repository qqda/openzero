local jwt = require "resty.jwt"
local http = require "resty.http"
local cjson = require "cjson"
local socket = require("socket")
--local dns = require "socket.dns"  -- DNS-Auflösung für Hostname → IP
local vvv = "Policy v.1.48" 
-- print(socket._VERSION)
ngx.say(socket._VERSION)
ngx.say(vvv)

-- Resolve IP-Adresse von "opa"
local opa_ip = "127.0.0.1"  -- fallback
do
  local resolved, err = socket.dns.toip("opa")
  if resolved then
    opa_ip = resolved
  end
end

ngx.say("OPA IP:", opa_ip)

local function log_access(status, user, role, method, path, reason)
  local log_msg = string.format(
    '[%s] user="%s" role="%s" method="%s" path="%s" access="%s" reason="%s"',
    os.date("%Y-%m-%d %H:%M:%S"), user or "-", role or "-", method, path, status, reason or "-"
  )
  local file = io.open("/var/log/nginx/zero-trust.log", "a")
  if file then
    file:write(log_msg .. "\n")
    file:close()
  end
end

local token = ngx.req.get_headers()["Authorization"]
if not token or not token:find("Bearer ") then
  log_access("denied", nil, nil, ngx.req.get_method(), ngx.var.uri, "no token")
  ngx.status = 401
  ngx.say("Missing or invalid Authorization header")
  return ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

token = token:gsub("Bearer ", "")
local jwt_obj = jwt:verify("secret123secret123secret123secret123", token)

if not jwt_obj.verified then
  log_access("denied", nil, nil, ngx.req.get_method(), ngx.var.uri, "invalid token")
  ngx.status = 401
  ngx.say("Invalid token: ", jwt_obj.reason)
  return ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

local user = jwt_obj.payload.sub
local role = jwt_obj.payload.role
local path = ngx.var.uri
local method = ngx.req.get_method()

local httpc = http.new()
local res, err = httpc:request_uri("http://" .. opa_ip .. ":8181/v1/data/httpapi/authz/allow", {
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

if not res then
  log_access("denied", user, role, method, path, "OPA error")
  ngx.status = 403
  ngx.say("OPA error: ", err)
  return ngx.exit(ngx.HTTP_FORBIDDEN)
end

local result = cjson.decode(res.body)
if result.result ~= true then
  log_access("denied", user, role, method, path, "policy denied")
  ngx.status = 403
  ngx.say("Access Denied")
  return ngx.exit(ngx.HTTP_FORBIDDEN)
end

log_access("allowed", user, role, method, path, "policy allow")
