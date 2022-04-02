function _G.dump(...)
	local objects = vim.tbl_map(vim.inspect, { ... })
	print(_G.unpack(objects))
end
