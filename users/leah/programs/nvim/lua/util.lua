--- @module 'util'
local util = {}

-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
-- empty mode is same as using <cmd> :map
-- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
function util.wrapping_cursor(key, desc)
	return {
		'v:count || mode(1)[0:1] == "no" ? "' .. key .. '" : "g' .. key .. '"',
		desc = desc,
		expr = true,
	}
end

function util.register_keymap(map)
	for mode, key in pairs(map) do
		for keybind, settings in pairs(key) do
			local action = table.remove(settings, 1)
			vim.keymap.set(mode, keybind, action, settings)
		end
	end
end

return util
