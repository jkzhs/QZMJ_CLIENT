-- local util = require("util")
local table = table
local global = require("global")
local MSGQUEUE_LIMIT = 100--100000
local OP_BIND = 1
local OP_UNBIND = 2
local M = {}
local mq_mt = {}
M._mq_mt = mq_mt
local msg_mt = {
  -- __newindex = util.FORBID_NEWINDEX
}
mq_mt.__index = mq_mt
-- mq_mt.__newindex = util.FORBID_NEWINDEX
function mq_mt:mq_init()
  self.v_dispatching = {}
  self.v_mq = {}
  self.v_sz = 0
  self.v_msg_handler = {}
  self.v_unhandled_handler = {}
  self.v_unhandled_ud = {}
  self.v_recycle_handler = {}
  self.v_freelist = {}
  self.v_freesize = 0
  self.v_handle_to_index = {}
  self.v_next_handle = 1
  self.v_pending_ops = {0}
  self.v_pending_flag = false
  self.v_pending_dirty = false
  self.v_stat_new = 0
  self.v_stat_reuse = 0
  self.v_stat_recycle = 0
end
function mq_mt:mq_register(msgtype)
  self.v_msg_handler[msgtype] = {0}
end
function mq_mt:_mq_newmsg()
  local i = self.v_freesize
  if i > 0 then
    self.v_stat_reuse = self.v_stat_reuse + 1
    self.v_freesize = i - 1
    return self.v_freelist[i]
  end
  self.v_stat_new = self.v_stat_new + 1
  return setmetatable({
    mm_type = 0,
    mm_obj = false,
    mm_x = false,
    mm_y = false
  }, msg_mt)
end
function mq_mt:mq_publish2(msgtype, mm_obj)
  local msg = self:_mq_newmsg()
  msg.mm_type = assert(msgtype, "msgtype is nil")
  msg.mm_obj = mm_obj
  -- msg.mm_x = false
  -- msg.mm_y = false

  local i = self.v_sz + 1
  self.v_mq[i] = msg
  self.v_sz = i
  return msg
end
function mq_mt:_mq_pend_op(op, p1, p2, p3, p4)
  local t = self.v_pending_ops
  local n = t[1]
  local i = 1 + n * 5
  t[i + 1] = op
  t[i + 2] = p1
  t[i + 3] = p2
  t[i + 4] = p3
  t[i + 5] = p4
  self.v_pending_dirty = true
  t[1] = n + 1
  return
end
function mq_mt:_mq_exec_pendings()
  local t = self.v_pending_ops
  local n = t[1]
  for index = 0, n - 1 do
    local i = 1 + index * 5
    local op, p1, p2, p3, p4 = t[i + 1], t[i + 2], t[i + 3], t[i + 4], t[i + 5]
    t[i + 1], t[i + 2], t[i + 3], t[i + 4], t[i + 5] = nil, nil, nil, nil, nil
    global.log("[MSGQUEUE] execute pending op:" .. tostring(op) .. " msgtype:" .. tostring(p1))
    if op == OP_BIND then
      local i = self:_mq_bind_aux(p1, p2, p3)
      self.v_handle_to_index[p4] = i
    elseif op == OP_UNBIND then
      self:mq_unbind(p1, p2)
    else
      error("[MSGQUEUE] unknown op:" .. tostring(op))
    end
  end
  t[1] = 0
end
function mq_mt:_mq_bind_aux(msgtype, handler, ud)
  local list = self.v_msg_handler[msgtype]
  local c = list[1]
  local i = 1
  for i = 2, MSGQUEUE_LIMIT, 2 do
    if not list[i] then
      list[i] = handler
      list[i + 1] = ud
      list[1] = c + 1
      return i
    end
  end
  error("[MSGQUEUE] bind failed! msgtype:" .. tostring(msgtype))
end
function mq_mt:mq_bind(msgtype, handler, ud)
  assert(handler)
  local handle = self.v_next_handle
  self.v_next_handle = handle + 1
  if self.v_pending_flag then
    self:_mq_pend_op(OP_BIND, msgtype, handler, ud, handle)
    return handle
  else
    local i = self:_mq_bind_aux(msgtype, handler, ud)
    self.v_handle_to_index[handle] = i
    return handle
  end
end
function mq_mt:mq_unbind(msgtype, handle)
  if self.v_pending_flag then
    return self:_mq_pend_op(OP_UNBIND, msgtype, handle)
  end
  local list = self.v_msg_handler[msgtype]
  local i = assert(self.v_handle_to_index[handle])
  self.v_handle_to_index[handle] = nil
  list[i] = nil
  list[i + 1] = nil
  list[1] = list[1] - 1
end
function mq_mt:mq_set_recycle_handler(msgtype, handler)
  self.v_recycle_handler[msgtype] = handler
end
function mq_mt:mq_dispatch()
  self.v_dispatching, self.v_mq = self.v_mq, self.v_dispatching
  local dispatching_sz = self.v_sz
  self.v_sz = 0
  local mq = self.v_dispatching
  local msg_handler = self.v_msg_handler
  self.v_pending_flag = true
  for i = 1, dispatching_sz do
    local msg = mq[i]
    local msgtype = msg.mm_type
    local list = msg_handler[msgtype]
    if not list then
      error(tostring(msgtype))
    end
    local n = list[1]
    if n > 0 then
      for j = 2, MSGQUEUE_LIMIT, 2 do
        local handler = list[j]
        if handler then
          handler(list[j + 1], msg)
          n = n - 1
        end
        if not (n <= 0) then
        end
      end
      if n > 0 then
        error(("msgqueue dispatch failed! msgtype:%s n:%s"):format(msgtype, n))
      end
    else
      local h = self.v_unhandled_handler[msgtype]
      if h then
        h(self.v_unhandled_ud[msgtype], msg)
      end
    end
    self:_recycle_msg(msg)
  end
  self.v_pending_flag = false
  if self.v_pending_dirty then
    self.v_pending_dirty = false
    self:_mq_exec_pendings()
  end
end
function mq_mt:mq_clear_freelist()
  local list = self.v_freelist
  for i = 1, self.v_freesize do
    local msg = list[i]
    msg.mm_type = 0
    msg.mm_obj = false
    msg.mm_x = false
    msg.mm_y = false
  end
end
function mq_mt:mq_clear()
  self.v_sz = 0
  local handlers = self.v_msg_handler
  for msgtype, _ in pairs(handlers) do
    handlers[msgtype] = {0}
  end
  local uhandlers = self.v_unhandled_handler
  local unhandled_ud = self.v_unhandled_ud
  for msgtype, _ in pairs(uhandlers) do
    uhandlers[msgtype] = nil
    unhandled_ud[msgtype] = nil
  end
end
function mq_mt:mq_report(log)
  return log(("[MSG QUEUE] size:%d freesize:%d new:%d reuse:%d recycle:%d"):format(self.v_sz, self.v_freesize, self.v_stat_new, self.v_stat_reuse, self.v_stat_recycle))
end
function mq_mt:_recycle_msg(msg)
  local f = self.v_recycle_handler[msg.mm_type]
  if f then
    f(msg)
  end
  local i = self.v_freesize + 1
  self.v_freelist[i] = msg
  self.v_freesize = i
  self.v_stat_recycle = self.v_stat_recycle + 1
end
function M.mq_create_ex(entries)
  local mq = M.mq_create()
  mq:mq_init()
  for i = 1, #entries do
    mq:mq_register(entries[i])
  end
  return mq
end
function M.mq_create()
  local raw = {
    v_dispatching = false,
    v_mq = false,
    v_sz = false,
    v_msg_handler = false,
    v_unhandled_handler = false,
    v_unhandled_ud = false,
    v_recycle_handler = false,
    v_freelist = false,
    v_freesize = false,
    v_stat_new = false,
    v_stat_reuse = false,
    v_stat_recycle = false,
    v_pending_ops = false,
    v_pending_flag = false,
    v_pending_dirty = false,
    v_handle_to_index = false,
    v_next_handle = false
  }
  local self = setmetatable(raw, mq_mt)
  self:mq_init()
  return self
end
return M
