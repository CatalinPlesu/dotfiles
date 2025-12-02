local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

ls.add_snippets("all", {
	s("h1", {
		t("# "),
		i(1, "heading"),
	}),
})

ls.add_snippets("all", {
	s("h2", {
		t("## "),
		i(1, "heading"),
	}),
})

ls.add_snippets("all", {
	s("wl", {
		t("[["),
		i(1, "link"),
		t("]]"),
	}),
})
