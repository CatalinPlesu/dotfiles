function clemens_highlight()
  -- Get the current buffer's filename
  local filename = vim.fn.expand('%:t') -- Get the filename without the path

  -- Capture the list of files from git status and extract filenames
  local function get_files_from_git_status(grep_pattern)
    local handle = io.popen(
      'git status --porcelain=v2 | sed -E \'s/[0-9]{6} [0-9]{6} [0-9]{6} [a-f0-9]{40} [a-f0-9]{40} //\' | grep "' ..
      grep_pattern .. '" | awk -F\'[[:space:]]\' \'{print $(NF)}\' | awk -F\'/\' \'{print $NF}\''
    )
    local result = handle:read("*a")
    handle:close()
    return result
  end

  -- Get the list of files to highlight in green and red
  local files_to_highlight_green = get_files_from_git_status("M. ")
  local files_to_highlight_red = get_files_from_git_status(".M ")

  -- Split the output into lines
  local function split_lines(input)
    local lines = {}
    for line in input:gmatch("[^\r\n]+") do
      table.insert(lines, line)
    end
    return lines
  end

  local file_list_green = split_lines(files_to_highlight_green)
  local file_list_red = split_lines(files_to_highlight_red)

  -- Start with the tree command
  local cmd = 'tree -I "bin|obj" -F'

  -- Add existing highlighting for the current filename
  cmd = cmd .. ' | sed "s/' .. filename .. '/\\x1b[38;2;255;255;255m\\x1b[48;2;213;196;161m&\\x1b[0m/g"'

  -- Add highlighting for additional files
  for _, file in ipairs(file_list_green) do
    cmd = cmd .. ' | sed "s/' .. file .. '/\\x1b[38;2;0;128;0m&\\x1b[0m/g"'
  end

  for _, file in ipairs(file_list_red) do
    cmd = cmd .. ' | sed "s/' .. file .. '/\\x1b[31m&\\x1b[0m/g"'
  end

  -- Open a new vertical split terminal and execute the command
  vim.api.nvim_command('vnew')                               -- Open a vertical split
  vim.api.nvim_command('setlocal nobuflisted noswapfile buftype=nofile bufhidden=wipe')
  vim.api.nvim_command('setlocal nonumber norelativenumber') -- Disable line numbers

  local term_buf = vim.api.nvim_get_current_buf()
  local term_id = vim.fn.termopen(cmd, {
    on_exit = function()
      vim.api.nvim_buf_set_lines(term_buf, -2, -1, false, {})
    end
  })

  -- Define key mapping to close the terminal with 'q'
  vim.api.nvim_buf_set_keymap(term_buf, 'n', 'q', ':bwipeout!<CR>', { noremap = true, silent = true })

  -- Start in insert mode
  vim.api.nvim_command('startinsert')
end

-- Create a command to call the function
vim.api.nvim_command('command! ShowFileInTree lua clemens_highlight()')

return {}
