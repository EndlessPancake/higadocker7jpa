local host = ngx.var.dest_host
local port = tonumber(ngx.var.dest_port)

local sock = ngx.socket.tcp()
sock:settimeout(1000)
-- local ok, err = sock:connect(proxy_host, proxy_port)
local ok, err = sock:connect("10.174.0.6", 8888)

local uri = string.format('CONNECT %s:%s HTTP/1.1', host, port)
local header = string.format('Host: %s:%s', host, port)
local request = table.concat({uri, header}, '\r\n') .. '\r\n\r\n'
local bytes, err = sock:send(request)
local data, err, partial = sock:receive('*l')
if err then
    ngx.log(ngx.DEBUG, err)
    ngx.exit(ngx.HTTP_BAD_REQUEST)
end

local m, err = ngx.re.match(data, '^HTTP/1\\.(0|1) 2\\d{2}\\s.+')
if err then
    ngx.log(ngx.DEBUG, err)
    ngx.exit(ngx.HTTP_BAD_REQUEST)
end

local session, err = sock:sslhandshake()
local method = ngx.req.get_method()
local uri = string.format('%s %s HTTP/1.1', method, ngx.var.uri)
local header = string.format('Host: %s:%s', host, port)
local request = table.concat({uri, header}, '\r\n') .. '\r\n\r\n'
local bytes, err = sock:send(request)
local iter = sock:receiveuntil('\r\n\r\n')

local data, err, partial = iter()
if err then
    ngx.log(ngx.DEBUG, err)
end

local header, n, err = string.gsub(data, '^\r\n', '')
local m, err = ngx.re.match(header, 'Content-Length:\\s(.+)', 'i')
if err then
    local ok, err = sock:close()
    if err then
        ngx.exit(ngx.HTTP_BAD_REQUEST)
    end
    ngx.exit(ngx.HTTP_BAD_REQUEST)
end

local length = tonumber(m[1])
local body, err, partial = sock:receive(length)
if err then
    local ok, err = sock:close()
    if err then
        ngx.exit(ngx.HTTP_BAD_REQUEST)
    end
    ngx.exit(ngx.HTTP_BAD_REQUEST)
end

local ok, err = sock:close()
if err then
    ngx.exit(ngx.HTTP_BAD_REQUEST)
end

local ok, err = sock:close()
if err then
    ngx.exit(ngx.HTTP_BAD_REQUEST)
end

local iter, err = ngx.re.gmatch(header, '(.+):\\s*(.+)')
while true do
    local m, err = iter()
    if err then
        ngx.exit(ngx.HTTP_BAD_REQUEST)
    end

    if m then
        if m[1] then
            local from, to, err = ngx.re.find(m[1], 'content-length', 'i')
            if err then
                ngx.exit(ngx.HTTP_BAD_REQUEST)
            end

            if not from then
                ngx.header[m[1]] = m[2]
            end
        end
    else
        break
    end
end

ngx.print(body)
ngx.exit(ngx.HTTP_OK)
