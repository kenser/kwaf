require "waf/tools"
require "resty.core.regex"
local cjson = require "cjson";
local engine = require "waf/waf_engine"

local _M = {}

local mt = {  __index = _M }
local get_headers = ngx.req.get_headers

function _M.new()
    local t = {
        var = {},
    }
    return setmetatable(t, mt)
end

function _M.xss_rule()
    local XSS_RULES_JSON = get_rule('xss')
    local XSS_RULES = cjson.decode(XSS_RULES_JSON);
    local waf_engine = engine:new()
    for _, rule in pairs(XSS_RULES) do
        ngx.log(ngx.INFO, "rule id "..rule.rule_id)
        xss_res = waf_engine:run(rule.content)
        if xss_res then
            return true
        end
    end
    return false
end

function _M.check(self)
    if self:xss_rule() then
        return ngx.exit(ngx.HTTP_BAD_REQUEST)
    end
    -- if all rule pass
    return true
end

return _M
