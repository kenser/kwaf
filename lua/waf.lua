local config = require 'config'
local web_general_sec = require 'waf/web_general_sec'
local http_protocol_validation = require 'waf/http_protocol_validation'
local upload_limit = require 'waf/upload_limit'

local method = ngx.req.get_method()
local headers = ngx.req.get_headers()

if config.waf_enable then
    if config.http_protocol_validation then
        local http_protocol_validation = http_protocol_validation:new()
        http_protocol_validation:check_in_strategy()
    end
    if config.web_general_sec then
        local web_general_sec = web_general_sec:new()
        web_general_sec:check()
    end
    -- post need check file upload
    if method == 'POST' then
        if string.sub(headers["content-type"],1,20) == 'multipart/form-data;' then
            if config.upload_limit then
                local upload_limit = upload_limit:new()
                upload_limit:check()
            end
        end
    end
    -- todo:
    -- white list
    -- black list
    -- upload limit
    -- download limit
    -- info leak
    -- brute force
end
