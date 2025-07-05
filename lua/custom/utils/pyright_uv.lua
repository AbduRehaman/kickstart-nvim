local M = {}

-- Smart root finder: prefers LSP root, then falls back to git/pyproject.toml, then CWD
local function get_project_root()
  -- Use LSP workspace root if available
  local clients = vim.lsp.get_active_clients { bufnr = 0 }
  for _, client in ipairs(clients) do
    local workspace_folders = client.config.workspace_folders
    if workspace_folders and #workspace_folders > 0 then
      return vim.uri_to_fname(workspace_folders[1].uri)
    elseif client.config.root_dir then
      return client.config.root_dir
    end
  end

  -- Fallback: look for common project markers
  local marker = vim.fs.find({ '.git', 'pyproject.toml', 'setup.py', 'requirements.txt' }, {
    upward = true,
    path = vim.fn.expand '%:p:h',
  })[1]

  return marker and vim.fs.dirname(marker) or vim.fn.getcwd()
end

-- Simple y/N confirm prompt
local function confirm(prompt)
  return vim.fn.input(prompt .. ' [y/N]: '):lower() == 'y'
end

-- Main function to setup uv venv and pyrightconfig.json
function M.setup_uv_pyright()
  local root = get_project_root()
  local venv_path = root .. '/.venv'
  local uv_exists = vim.fn.executable 'uv' == 1

  if not uv_exists then
    print "❌ 'uv' is not installed. Install it via `brew install uv` or `pipx install uv`."
    return
  end

  if vim.fn.isdirectory(venv_path) == 1 then
    if not confirm('⚠️ .venv already exists in ' .. root .. '. Overwrite?') then
      print '❌ Aborted.'
      return
    end
    vim.fn.delete(venv_path, 'rf')
  end

  -- Run uv venv
  print '⏳ Creating virtual environment with uv...'
  local result = vim.fn.system { 'uv', 'venv', '.venv' }
  if vim.v.shell_error ~= 0 then
    print('❌ Failed to create venv with uv:\n' .. result)
    return
  end

  -- Set python path
  local python_path = venv_path .. '/bin/python'
  if vim.loop.os_uname().sysname == 'Windows_NT' then
    python_path = venv_path .. '\\Scripts\\python.exe'
  end

  -- Generate pyrightconfig.json
  local config = {
    typeCheckingMode = 'basic',
    venv = '.venv',
    venvPath = root,
    pythonPath = python_path,
  }

  local file = io.open(root .. '/pyrightconfig.json', 'w')
  if not file then
    print '❌ Failed to write pyrightconfig.json.'
    return
  end

  file:write(vim.fn.json_encode(config))
  file:close()

  print('✅ Created .venv and pyrightconfig.json in: ' .. root)
end

return M
