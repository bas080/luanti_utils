# luanti_utils

Utils that might can make it easier for you to make mods.

Each util can be required seperatly into your mod. It does require you to depend on this mod.

## Documentation

Add luanti_utils as a dependency.

Then you can require only the utils you want. The others won't be sourced and parsed.

```lua
local util = luanti_utils.dofile('<luanti_util>.lua')
```

See [Luanti Utils Documentation][luanti_utils_doc].

> The util files themselves have [LDoc][LDoc] comments. These are used to generate any documentation.

## License

TBD

[luanti_utils_doc]:https://bas080.github.io/luanti_utils/index.html
[LDoc]:https://stevedonovan.github.io/ldoc/
