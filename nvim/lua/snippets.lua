local ls = require "luasnip"
local snippet = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local fmt = require("luasnip.extras.fmt").fmt
local m = require("luasnip.extras").m
local lambda = require("luasnip.extras").l

ls.add_snippets("c", {
	snippet (
		"main", {
		t("int main(int argc, char *argv[]) {"),
		t({"", "	"}), i(0),
		t({"", "}"})
	}),
	snippet (
		"choice",
		c (1, {
			sn(nil, {i(1), t('This is the first choice 1')}),
			sn(nil, {i(2), t('This is the second choice 2')}),
			sn(nil, {i(3), t('This is the third choice 3')})
		})
	)
})

vim.keymap.set({ "i", "s" }, "<Tab>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

-- vim.keymap.set("i", "<c-k>", require'luasnip.extras.select_choice')
