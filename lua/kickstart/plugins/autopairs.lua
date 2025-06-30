-- autopairs
-- https://github.com/windwp/nvim-autopairs

return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  opts = {
    check_ts = true, -- Enables Treesitter-based context awareness
    fast_wrap = {}, -- Optional: enables fast wrapping with <M-e>
  },
}
