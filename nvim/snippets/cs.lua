local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s("prop", {
		i(1, "public"),
		t(" "),
		i(2, "string"),
		t(" "),
		i(3, "MyProperty"),
		t(" { get; set; }"),
		i(0),
	}),
}
