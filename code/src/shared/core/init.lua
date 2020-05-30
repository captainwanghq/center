require "socket"
require "core.global.utils"
cs = cs or {}
cs.ui_event = require("core.global.g_event").new()
cs.file = {}
cs.list = {}
cs.stack = {}
cs.deque = {}
cs.timer_mgr = require('core.global.g_timer').new()
cs.timer_mgr:start()
if CC_DISABLE_GLOBAL then
    cc.disable_global()
end
