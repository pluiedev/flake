local colorizer = require("colorizer")
-- local css = {
--   RRGGBBAA = true,
--   css = true,
-- }

colorizer.setup({
	-- css = css,
	-- scss = css,
	-- sass = css,
	-- "html",
})

-- execute colorizer as soon as possible
vim.defer_fn(function()
	colorizer.attach_to_buffer(0)
end, 0)
