; extends

; Highlight YAML block scalars as another language based on the mapping key.
; e.g.
;   script: |
;     echo "highlighted as bash"
(block_mapping_pair
  key: (flow_node (plain_scalar (string_scalar) @_key)
    (#any-of? @_key "script" "run" "before_script" "after_script" "command"))
  value: (block_node (block_scalar) @injection.content
    (#set! injection.language "bash")))
