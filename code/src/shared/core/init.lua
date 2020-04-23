require "core.global.init"
require "socket"
cs = cs or {}
cs.ui_event = require("core.global.g_event").new()
cs.file = {}
cs.list = {}
cs.stack = {}
cs.deque = {}
if CC_DISABLE_GLOBAL then
    cc.disable_global()
end
