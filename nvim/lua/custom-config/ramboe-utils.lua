require("dap-scope-walker").setup()
require("helpers")

map("n", "<leader>aa", HighlightCSharpMethod, "Highlight C# Method Body")
map("n", "<leader>co", CloseOtherBuffers, "Close other buffers")
