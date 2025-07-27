from typing import List, Optional, Union, Callable, Tuple, Any
import subprocess
import sys
import os

class Rofi:
    def __init__(self):
        self.is_on = False

    def dmenu(self, 
             prompt: str, 
             options: List[str], 
             allow_custom: bool = False) -> Optional[str]:
        """Original rofi dmenu implementation"""
        cmd = ["rofi", "-dmenu", "-i", "-p", prompt]
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
        if proc.returncode == 0:
            return proc.stdout.strip()
        return None

    def show_menu(self,
                 items: List[Union[
                     str,
                     Tuple[str, Callable],
                     Tuple[str, Callable, Tuple[Any, ...]]
                 ]],
                 prompt: str = "Select:",
                 allow_custom: bool = False) -> Optional[str]:
        """
        Enhanced menu with callback support
        
        Args:
            items: List of either:
                  - str (display text only)
                  - (str, Callable) (display text and callback)
                  - (str, Callable, tuple) (display text, callback, and arguments)
            prompt: Menu prompt text
            allow_custom: Whether to allow custom user input
            
        Returns:
            The selected display text or custom input
        """
        # Extract display texts
        display_options = []
        callbacks = {}
        
        for item in items:
            if isinstance(item, str):
                display_options.append(item)
            elif len(item) == 2:  # (text, callback)
                text, callback = item
                display_options.append(text)
                callbacks[text] = (callback, ())
            elif len(item) >= 3:  # (text, callback, args)
                text, callback, *args = item
                display_options.append(text)
                callbacks[text] = (callback, args[0] if args else ())
        
        # Show menu
        selected = self.dmenu(prompt, display_options, allow_custom)
        
        # Execute callback if exists
        if selected in callbacks:
            callback, args = callbacks[selected]
            callback(*args)
        
        return selected
