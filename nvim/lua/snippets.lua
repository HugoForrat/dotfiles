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

ls.config.set_config {
	update_events = "TextChanged,TextChangedI"
}

ls.add_snippets("c", {
	snippet (
		"main", {
		t("int main(int argc, char *argv[]) {"),
		t({"", "	"}), i(0),
		t({"", "}"})
	})
})

ls.add_snippets("python", {
	snippet (
	"main", {
		t("if __name__ == '__main__':"),
		t({"", "	main()"}) -- TODO: use expandtab setting instead of hardcoding a tab
	})
})

-- Basic Latex Commands
local latex_commands = {
	e = 'emph',
	tt = 'texttt',
	i = 'textit',
	b = 'textbf',
	url = 'url'
}

for key, val in pairs(latex_commands) do
	ls.add_snippets("tex", {
		snippet (
			key, {
				t("\\" .. val .. "{"), i(1), t("}"),
			}
		)
	})
end

ls.add_snippets("tex", {
	snippet (
		"\"", {
				t("``"), i(1), t("''"),
			}
	),
	snippet (
		"beg", {
			t("\\begin{"), i(1), t("}"),
			t(""), i(2),
			t({"", "\\end{"}),
			d(
				3,
				function(args) return sn(nil, { t(args[1]) }) end,
				{1}
			),
			t("}")
		}
	),
	snippet (
		"list", {
			t("\\begin{itemize}"),
			t({"", "\\item "}), i(0),
			t({"", "\\end{itemize}"})
		}
	)
})

vim.keymap.set({ "i", "s" }, "<Tab>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

-- vim.keymap.set("i", "<c-k>", require'luasnip.extras.select_choice')
