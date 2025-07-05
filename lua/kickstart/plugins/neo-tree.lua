-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    close_if_last_window = true,
    enable_git_status = true,
    enable_diagnostics = false,
    filesystem = {
      filtered_items = {
        visible = true, -- Show filtered items (dotfiles, etc.)
        hide_dotfiles = false,
        hide_gitignored = false,
      },
      follow_current_file = {
        enabled = true, -- Keep Neo-tree in sync with current file
      },
      bind_to_cwd = true,
      use_libuv_file_watcher = true, -- Auto-refresh on file changes
      window = {
        mappings = {
          ['<CR>'] = 'open', -- Enter opens file in buffer
          ['\\'] = 'close_window', -- \ closes Neo-tree
          ['v'] = 'open_vsplit', -- v splits file vertically
          ['s'] = 'open_split', -- s splits file horizontally
          ['y'] = function(state)
            local node = state.tree:get_node()
            local path = node.path or node:get_id()
            vim.fn.setreg('+', path)
            print('Copied absolute path: ' .. path)
          end,
        },
      },
    },
  },
}
