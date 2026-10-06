; extends
; Brace blocks ({ ... }) are not captured in nvim-treesitter's folds query
; while do..end blocks are. Capture the `block` node to make them foldable.
; https://github.com/nvim-treesitter/nvim-treesitter/discussions/8686
(block) @fold
