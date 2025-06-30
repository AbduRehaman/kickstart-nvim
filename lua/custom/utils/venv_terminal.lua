local M = {}

-- Open terminal in the current file's directory and activate .venv if it exists
function M.open_terminal_with_venv()
  local buf_path = vim.api.nvim_buf_get_name(0)
  if buf_path == '' then
    vim.notify('No active file detected', vim.log.levels.WARN)
    return
  end

  local dir = vim.fn.fnamemodify(buf_path, ':p:h')
  local activate_path = dir .. '/.venv/bin/activate'

  -- Open terminal at bottom
  vim.cmd 'botright split | terminal'

  local term_chan = vim.b.terminal_job_id
  if not term_chan then
    vim.notify('Terminal channel not ready', vim.log.levels.ERROR)
    return
  end

  -- Change to file's directory
  vim.api.nvim_chan_send(term_chan, 'cd ' .. dir .. '\n')

  -- Activate .venv if it exists
  if vim.fn.filereadable(activate_path) == 1 then
    vim.api.nvim_chan_send(term_chan, 'source .venv/bin/activate\n')
  else
    vim.notify('.venv not found in ' .. dir, vim.log.levels.INFO)
  end
end

-- Keymap (normal mode): <leader>tv to open terminal + venv
vim.keymap.set('n', '<leader>tv', M.open_terminal_with_venv, {
  desc = 'Open terminal and activate .venv',
  noremap = true,
  silent = true,
})

return M
