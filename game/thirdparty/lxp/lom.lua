-- See Copyright Notice in license.html
-- $Id: lom.lua,v 1.6 2005/06/09 19:18:40 tuler Exp $

require "lxp"
local class = require "class"

local tinsert, tremove, getn = table.insert, table.remove, table.getn
local assert, type, print = assert, type, print
local lxp = lxp
local pairs, ipairs = pairs, ipairs
local table = table

module ("lxp.lom")

local CXML = class.make{}
function CXML:findOne(tag, attr, value, no_recurs)
	local function search(t)
		for _, node in ipairs(t) do
			if type(node) == "table" then
				if node.tag == tag and (not attr or node.attr[attr] == value) then
					return CXML.castAs(node)
				elseif not no_recurs then
					local r = search(node)
					if r then return r end
				end
			end
		end
	end
	return search(self)
end
function CXML:findAll(tag, attr, value, no_recurs)
	local list = {}
	local function search(t)
		for _, node in ipairs(t) do
			if type(node) == "table" then
				if node.tag == tag and (not attr or node.attr[attr] == value) then
					list[#list+1] = CXML.castAs(node)
				elseif not no_recurs then
					search(node)
				end
			end
		end
	end
	search(self)
	return list
end
function CXML:findAllAttrs(tag, key, value)
	local list = self:findAll(tag)
	local attrs = {}
	for i, node in ipairs(list) do
		if node.attr[key] and node.attr[value] then
			attrs[node.attr[key]] = node.attr[value]
		end
	end
	return attrs
end
function CXML:findAllAttrsValueOrBody(tag, key, value)
	local list = self:findAll(tag)
	local attrs = {}
	for i, node in ipairs(list) do
		if node.attr[key] then
			if node.attr[value] then
				attrs[node.attr[key]] = node.attr[value]
			else
				attrs[node.attr[key]] = node[1]
			end
		end
	end
	return attrs
end

local function starttag (p, tag, attr)
	local stack = p:getcallbacks().stack
	local newelement = {tag = tag, attr = attr}
	tinsert(stack, newelement)
end

local function endtag (p, tag)
	local stack = p:getcallbacks().stack
	local element = tremove(stack)
	assert(element.tag == tag)
	local level = getn(stack)
	tinsert(stack[level], element)
end

local function text (p, txt)
	local stack = p:getcallbacks().stack
	local element = stack[getn(stack)]
	local n = getn(element)
	if type(element[n]) == "string" then
		element[n] = element[n] .. txt
	else
		tinsert(element, txt)
	end
end

function  parse (o)
	local c = { StartElement = starttag,
							EndElement = endtag,
							CharacterData = text,
							_nonstrict = true,
							stack = {{}}
						}
	local p = lxp.new(c)
	local status, err
	if type(o) == "string" then
		status, err = p:parse(o)
		if not status then return nil, err end
	else
		for l in o do
			status, err = p:parse(l)
			if not status then return nil, err end
		end
	end
	status, err = p:parse()
	if not status then return nil, err end
	p:close()
	return CXML.castAs(c.stack[1][1])
end

