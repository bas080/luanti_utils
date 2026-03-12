function migrate_node(name, nodenames, action)
  core.register_lbm({
    name = name,
    run_at_every_load = false,
    nodenames = nodenames,
    action = action,
  })
end

return migrate_node
