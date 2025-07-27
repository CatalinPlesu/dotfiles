import os


class QuteBrowser:
    def __init__(self):
        self._url = os.environ.get("QUTE_URL")
        self._title = os.environ.get("QUTE_TITLE")
        self._fifo_path = os.environ.get("QUTE_FIFO")
        # ADD THIS LINE TO DEBUG
        print(f"DEBUG: QUTE_FIFO path initialized as: {self._fifo_path}")

    def get_url(self):
        return self._url

    def get_title(self):
        return self._title

    def send_command(self, command: str):
        # ADD THIS LINE TO DEBUG
        print(f"DEBUG: Attempting to send command '{
              command}'. FIFO path: {self._fifo_path}")
        if not self._fifo_path:
            # ADD THIS
            print("ERROR: QUTE_FIFO path is not set. Cannot send command.")
            return
        try:
            with open(self._fifo_path, 'a') as fifo_file:
                fifo_file.write(command + '\n')
            print(f"DEBUG: Command '{
                  command}' successfully written to FIFO.")  # ADD THIS
        except (FileNotFoundError, IOError) as e:
            print(f"ERROR: Failed to write to FIFO: {e}")  # ADD THIS
            pass

    def open_url(self, url: str, new_tab: bool = False, new_window: bool = False):
        command = "open"
        if new_window:
            command += " -w"
        elif new_tab:
            command += " -t"
        command += f" {url}"
        self.send_command(command)
