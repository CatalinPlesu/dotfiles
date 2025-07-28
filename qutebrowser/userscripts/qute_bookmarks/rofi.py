from typing import List, Optional, Union, Callable, Tuple, Any, Dict
import subprocess


class Rofi:
    def __init__(self):
        self.is_on = False

    def dmenu(self,
              prompt: str,
              options: List[str],
              allow_custom: bool = False) -> Tuple[Optional[str], int]:
        """Rofi dmenu with support for Shift+H and Shift+L"""
        cmd = [
            "rofi", "-dmenu", "-i", "-p", prompt,
            "-matching", "prefix",
            "-sort",
            "-kb-move-char-back", "",
            "-kb-move-char-forward", "",
            "-kb-custom-1", "Left",
            "-kb-custom-2", "Right"
        ]
        if allow_custom:
            cmd.extend(["-mesg", "Type custom value and press Enter"])
        input_text = "\n".join(options) if options else ""
        proc = subprocess.run(
            cmd,
            input=input_text,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        selected = proc.stdout.strip() if proc.stdout else None
        return selected, proc.returncode

    def show_menu(self,
                  items: List[Union[
                      str,
                      Tuple[str, Callable],  # default enter
                      # enter, shift+h, shift+l
                      Tuple[str, Callable, Callable, Callable],
                      Tuple[str, Callable, Callable, Callable, Tuple[Any, ...],
                            Tuple[Any, ...], Tuple[Any, ...]]  # full
                  ]],
                  prompt: str = "Select:",
                  allow_custom: bool = False) -> Optional[str]:
        """
        Enhanced menu with support for Enter, Shift+H and Shift+L callbacks.

        Each item can be:
            - str
            - (text, enter_cb)
            - (text, enter_cb, shift_h_cb, shift_l_cb)
            - (text, enter_cb, shift_h_cb, shift_l_cb, enter_args, h_args, l_args)
        """
        display_options = []
        callback_map: Dict[str, Tuple[Optional[Callable], Optional[Callable],
                                      Optional[Callable], Tuple[Any, ...], Tuple[Any, ...], Tuple[Any, ...]]] = {}

        for item in items:
            if isinstance(item, str):
                display_options.append(item)
                callback_map[item] = (None, None, None, (), (), ())
            elif len(item) == 2:
                text, enter_cb = item
                display_options.append(text)
                callback_map[text] = (enter_cb, None, None, (), (), ())
            elif len(item) == 4:
                text, enter_cb, h_cb, l_cb = item
                display_options.append(text)
                callback_map[text] = (enter_cb, h_cb, l_cb, (), (), ())
            elif len(item) >= 7:
                text, enter_cb, h_cb, l_cb, enter_args, h_args, l_args = item
                display_options.append(text)
                callback_map[text] = (
                    enter_cb, h_cb, l_cb, enter_args, h_args, l_args)

        selected, code = self.dmenu(prompt, display_options, allow_custom)

        if selected is None:
            return None

        # If a selection was made AND it exists in our callback map,
        # then execute the corresponding callback.
        if selected in callback_map:
            enter_cb, h_cb, l_cb, enter_args, h_args, l_args = callback_map[selected]

            callback_executed = False  # Flag to track if any callback was executed

            if code == 0 and enter_cb:
                enter_cb(*enter_args)
                callback_executed = True
            elif code == 10 and h_cb:
                h_cb(*h_args)
                callback_executed = True
            elif code == 11 and l_cb:
                l_cb(*l_args)
                callback_executed = True

            # GUARD: If a callback was executed, we consider the action handled internally.
            # So, we return None to signify that no "new entity" needs to be processed
            # by the caller.
            if callback_executed:
                return None
            else:
                # This branch means it was in callback_map, but no specific callback
                # for the returned code was found (e.g., just a plain string item with no callbacks defined).
                # In this specific scenario, you might still want to return `selected`
                # or `None` based on your exact desired behavior.
                # Given your original intent, returning None here usually makes sense
                # if the item was "known" by the menu, even if no callback fired for the specific key.
                # Or you could return selected if you want to allow plain strings without callbacks to be processed.
                return None

        elif allow_custom and code == 0:
            # If allow_custom is True, and Rofi returned a value (code 0),
            # but it's not in our callback_map, it means it's a custom input.
            return selected
        else:
            # This covers cases where selected is not in callback_map,
            # allow_custom is False, or the return code is not 0 (e.g., Esc key).
            return None
