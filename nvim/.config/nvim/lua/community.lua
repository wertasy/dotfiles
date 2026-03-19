-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.motion.flash-nvim" },
  { import = "astrocommunity.diagnostics.tiny-inline-diagnostic-nvim" },
  { import = "astrocommunity.editing-support.multicursors-nvim" },
  -- import/override with your plugins folder
}
