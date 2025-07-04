local http = require "resty.http"
local cjson = require "cjson"

-- Extract Authorization header
local auth = ngx.req.get_headers()["Authorization"]
local user = "-"
local role = "-"

if auth and auth:find("Bearer ") then
  local token = auth:gsub("Bearer ", "")
  local parts = {}
  for part in string.gmatch(token, "[^%.]+") do
    table.insert(parts, part)
  end
  if #parts == 3 then
    local payload_b64 = parts[2]:gsub("-", "+"):gsub("_", "/")
    local payload_json = ngx.decode_base64(payload_b64)
    if payload_json then
      local payload = cjson.decode(payload_json)
      user = payload["sub"]
      role = payload["role"]
    end
  end
end

local httpc = http.new()
local res, err = httpc:request_uri("http://opa:8181/v1/data/httpapi/authz/allow", {
  method = "POST",
  body = cjson.encode({
    input = {
      user = user,
      role = role,
      path = { "data" },
      method = ngx.req.get_method()
    }
  }),
  headers = { ["Content-Type"] = "application/json" }
})

local success, result = pcall(cjson.decode, res.body)
if not success or not result or result.result ~= true then
  ngx.status = 403
  ngx.say("Access Denied (OPA failure or policy denied)")
  return ngx.exit(ngx.HTTP_FORBIDDEN)
end
