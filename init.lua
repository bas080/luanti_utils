local modpath = core.get_modpath(core.get_current_modname())

luanti_utils = {}

luanti_utils.dofile = function(module)
  return dofile(modpath .. '/' .. module)
end
