--- deferred_batch
-- Creates a batch-style deferred handler for multiple asynchronous tasks.
-- Provides per-task and all-tasks completion callbacks with result tracking.
--
--
-- @module deferred_batch.lua
--
--
--
-- @usage
-- local batch = deferred_batch()
--
-- -- Add async tasks
-- batch.add(function(done)
--     -- simulate async work
--     done("result 1")
-- end)
--
-- batch.add(function(done)
--     done("result 2")
-- end)
--
-- -- Per-task callback
-- batch.on_item_done(function(value, index)
--     print("Task", index, "finished with", value)
-- end)
--
-- -- All-tasks callback
-- batch.on_all_done(function(results)
--     print("All tasks completed. Results:", table.concat(results, ", "))
-- end)
--
-- @treturn deferredBatch A deferred batch table.

--- deferredBatch
-- @section deferredBatch

---
-- @table deferredBatch
-- @tfield function add Adds new asynchronous task.
-- @tfield function on_item_done Registers a callback `cb(value, index)` that
--   is invoked each time a task completes successfully. `index` corresponds to
--   the order in which tasks were added.
-- @tfield function on_all_done Registers a callback `cb(results)` that is
--   invoked once after all tasks have completed. If the batch is already finished,
--   the callback is invoked immediately.
-- @tfield boolean is_done Indicates whether all tasks have completed. True only
--   after all tasks have finished.

local function deferred_batch()
	local self = {}

	local pending = 0
	local results = {}
	local done_cbs = {}
	local all_done_cbs = {}

	self.is_done = true
	local finished = false
	local next_index = 0

	function self.call(fn)
		if finished then
			error("Cannot call after deferred is finished")
		end

		self.is_done = false
		pending = pending + 1
		next_index = next_index + 1
		local index = next_index

		fn(function(value)
			if results[index] ~= nil then
				error(("Callback for index %d called more than once"):format(index))
			end

			results[index] = value

			-- fire per-item callbacks
			for _, cb in ipairs(done_cbs) do
				cb(value, index)
			end

			pending = pending - 1

			if pending == 0 and not finished then
				finished = true
				self.is_done = true
				for _, cb in ipairs(all_done_cbs) do
					cb(results)
				end
			end
		end)
	end

	function self.done(cb)
		table.insert(done_cbs, cb)
	end

	function self.all_done(cb)
		if finished then
			cb(results)
		else
			table.insert(all_done_cbs, cb)
		end
	end

	return self
end

return deferred_batch
