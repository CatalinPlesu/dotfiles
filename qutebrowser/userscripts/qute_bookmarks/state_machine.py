from typing import Any, Callable, Dict, List, Optional, Tuple

class StateMachine:
    def __init__(
        self,
        initial_state: Any,
        state_definitions: List[Tuple[Any, Callable[['StateMachine'], Any]]],
        exit_states: List[Any]
    ):
        self._current_state = initial_state
        self._state_callbacks: Dict[Any, Callable[..., Any]] = {}
        self._context: Dict[str, Any] = {} # Initialized as empty
        self._exit_states = exit_states

        for state, callback in state_definitions:
            self.define_state(state, callback)

    @property
    def current_state(self) -> Any:
        return self._current_state

    @property
    def context(self) -> Dict[str, Any]:
        return self._context

    def define_state(self, state: Any, callback: Callable[..., Any]):
        self._state_callbacks[state] = callback

    def process_current_state(self) -> bool: # No *args, **kwargs here
        callback = self._state_callbacks.get(self._current_state)

        if callback:
            try:
                # Call callback, passing only 'self' (StateMachine instance)
                # Callbacks will access parameters directly from sm.context
                next_state = callback(self)

                if next_state is None:
                    return False
                elif next_state == self._current_state:
                    return True
                elif next_state not in self._state_callbacks and next_state is not None:
                    self._current_state = next_state
                    return True
                else:
                    self._current_state = next_state
                    return True
            except Exception as e:
                print(f"Error in state '{self._current_state}': {e}")
                return False
        else:
            return False

    def run(self, **kwargs): # Accepts **kwargs for initial parameters
        """
        Runs the state machine. Parameters passed to run() are stored in context.
        """
        self._context.update(kwargs) # Store parameters in context before running
        # print("--- State Machine Running ---") # Removed as per "no much prints"
        while True:
            state_being_processed = self.current_state

            should_continue_processing = self.process_current_state()

            if not should_continue_processing:
                break

            if state_being_processed in self._exit_states:
                break
        # print("--- State Machine Halted ---") # Removed as per "no much prints"
