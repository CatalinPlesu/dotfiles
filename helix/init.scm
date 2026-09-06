(require "grove/grove.scm")
(require "helix/keymaps.scm")

(grove-start!)

(keymap (global)
  (normal
    (space
      (e ":grove-toggle-focus!"))))
