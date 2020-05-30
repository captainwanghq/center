
local js = require("cjson")

local http = class("http")

function http:ctor(event_name,url,method,response_type,timeout,reqData)

    if url and string.sub(url,1,4) == "http" then

        self.event_name     = event_name

        self.url            = url

        self.timeout        = timeout or 10

        self.method         = method or "GET"                                                           ----默认是get

        if self.method == "POST" then

            self.requestData    = reqData

        end

        self.http_connector = cc.XMLHttpRequest:new() 
        
        self.http_connector.responseType  = response_type or cc.XMLHTTPREQUEST_RESPONSE_JSON            ----默认返回json

    else

        print("http创建失败")

    end

end

function http:request()

    if not self.url then return end

    print("http request:",self.url)

    self.http_connector:setRequestHeader("User-Agent",'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.6)')

    self.http_connector:setRequestHeader("accept",'*/*')

    self.http_connector:setRequestHeader("Content-Type",'application/json')

    self.http_connector:setRequestHeader("charset",'utf-8')

    self.http_connector:open(self.method, self.url)                                                     ----设置请求参数

    self.http_connector:registerScriptHandler(handler(self,self.response_event))                        ----注册回调
    
    if self.requestData then
        
        self.http_connector:send(self.requestData)                                                      ----发送请求

    else
        
        self.http_connector:send()                                                                      ----发送请求

    end
    
    self:start_timer(self.timeout)                                                                      ----curl在多线程下超时无效,添加一个计时器辅助超时判断

end

function http:set_download_complete(complete)
    
    if complete and type(complete) == "function" then

        self.complete = complete

    end

end

function http:start_timer(timeout)

    self.timer_id = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self,self.time_out),timeout,false)

end

function http:stop_timer()

    if self.timer_id then

        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.timer_id)

        self.timer_id = nil

    end

end

function http:time_out(dt)
    
    self:stop_timer()

    if self.http_connector then
        
        print("超时！！！！")

        self.http_connector:abort()

        self:clear()

    end

end

function http:response_event(data)
    
    self:stop_timer()

    if self.http_connector.readyState == 4 and (self.http_connector.status >= 200 and self.http_connector.status < 207) then

        if self.http_connector.responseType == cc.XMLHTTPREQUEST_RESPONSE_JSON then

            local response = self.http_connector.response

            if not response or response == "" then return end

            local lua_json = js.decode(response)        ----将json转成lua的table

            if lua_json and type(lua_json) == "table" then



            else
                print("解析格式错误(http)")
 
            end

        elseif self.http_connector.responseType == cc.XMLHTTPREQUEST_RESPONSE_STRING then  ----for download

            if self.complete then

                self.complete(self.http_connector.response)

                self.complete = nil

            end

        end

    else

        if self.http_connector.responseType == cc.XMLHTTPREQUEST_RESPONSE_STRING then ----下载失败

            if self.complete then

                self.complete(nil)

                self.complete = nil

            end
        else
            if self.event_name == "location_request" then return end

            print("网络连接失败，请检查网络")
        end
    end

    self:clear()

end

function http:clear()

    if self.http_connector then

        self.http_connector:unregisterScriptHandler()

        self.http_connector = nil

    end
    
end

return http