-- Rerun tests only if their modification time changed.
cache = true

ignore = {
  "631",  -- max_line_length
  "212/_.*",  -- unused argument, for vars with "_" prefix
}

allow_defined = true

-- Global objects defined by the C code
read_globals = {
  "vim",
}
