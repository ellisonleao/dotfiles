-- http module
local http_request = require("http.request")
local json = require("modules.json")

local M = {}

M.http_status = {OK = "200", BAD_REQUEST = "400", INTERNAL_SERVER_ERROR = "500"}

-- http request and json decoding for the body
local function make_and_parse_request(url)
  local headers, stream = assert(http_request.new_from_uri(url):go())
  local body = assert(stream:get_body_as_string())
  if headers:get(":status") ~= M.http_status.OK then
    error(headers:get(":status"), body)
  end

  return json.decode(body)
end

-- wrapping a get request
function M.get(url)
  return make_and_parse_request(url)
end

return M
