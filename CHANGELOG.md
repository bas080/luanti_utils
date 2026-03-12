# Changelog

## 0.0.0

Initial release.

- `luanti_utils.dofile`
  Helper to load Lua files relative to the current mod directory.

- Function extension utilities
  - `extend_function` – wrap existing functions with additional behavior.
  - `extend_item` – extend node callbacks while preserving access to the original callback.
  - `extend_group` – apply callback extensions to all nodes in a group.

- Node and map utilities
  - `emerge_node` – ensure a node is loaded before executing a callback.
  - `migrate_node` – helper for registering LBMs to migrate nodes.

- Inventory migration system
  - `migrate_inventory` – register migration functions for specific items.
  - Automatic migration when:
    - inventories are accessed via `core.get_meta`
    - players join the server.

- Player walk detection
  - `register_on_player_walk` – global callback when a player moves between nodes.
  - `node_on_player_walk` – node-level callbacks:
    - `on_player_walk_enter`
    - `on_player_walk_leave`

- Server idle task system
  - `on_server_idle` – run tasks only when the server has spare time.
  - `on_server_idle.wrap` – defer function execution to idle time.
  - Idle-based asynchronous table helpers:
    - `on_server_idle_each`
    - `on_server_idle_map`
    - `on_server_idle_filter`
    - `on_server_idle_reduce`

- Queue implementations
  - `queue` – simple in-memory FIFO queue.
  - `persistent_queue` – FIFO queue persisted using ModStorage.

- Utility helpers
  - `debounce` – delay execution until calls stop for a given duration.
  - `noop` – empty function helper.
