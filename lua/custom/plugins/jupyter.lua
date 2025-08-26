return {
  {
    'GCBallesteros/jupytext.nvim',
    config = function()
      require('jupytext').setup {
        style = 'percent', -- # %% style cells
        output_extension = 'ipynb',
        force_ft = 'python',
      }
    end,
  },
  {
    'bfredl/nvim-ipy',
    config = function()
      vim.g.nvim_ipy_perform_mappings = 0
      vim.keymap.set('n', '<leader>rr', '<cmd>IPythonCellRun<CR>')
      vim.keymap.set('n', '<leader>rc', '<cmd>IPythonCellExecuteCell<CR>')
    end,
  },
}
