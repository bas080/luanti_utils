function migrate_node(name, nodenames, action)
  core.register_lbm({
    name = name,
    run_at_every_load = true, -- TODO: Should only run during dev.
    nodenames = nodenames,
    action = action,
  })
end

return migrate_node
