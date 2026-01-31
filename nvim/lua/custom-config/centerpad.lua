local centerpad = require("centerpad")

map("n", "<leader>z", function()
  centerpad.toggle { leftpad = 22, rightpad = 22 }
end, "Toggle centerpad")
