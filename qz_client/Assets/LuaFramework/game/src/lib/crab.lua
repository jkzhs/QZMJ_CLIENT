--
-- Author: Albus
-- Date: 2016-03-12 15:16:40
-- Filename: crab.lua
-- 敏感词过渡
--
local crab = require "crab.c"
local utf8 = require "utf8.c"

local mt = {}

function mt:open()
	local buffer = cc.FileUtils:getInstance():getStringFromFile("stopword_sub.txt")
	local words_out = {}
	for k,v in pairs(string.split(buffer, ",")) do
		local t = {}
		assert(utf8.toutf32(v, t), "non utf8 words detected:"..v)
		words_out[#words_out+1] = t
	end
	crab.open(words_out)

	return self
end
function mt:close()
	crab.close()
end

function mt:filter(input)
	local texts = {}
	assert(utf8.toutf32(input, texts), "non utf8 words detected:", texts)
	local ret = crab.filter(texts)
	return ret, utf8.toutf8(texts)
end

--[[
	text的字数(中英文都为1个字)
	如："a" ：1个字, "开"：为1字
]]
function mt:text_len(text)
	return utf8.len(text)
end

return mt