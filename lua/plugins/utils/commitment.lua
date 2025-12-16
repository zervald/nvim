-- Remind me to commit
return {
  "nick-skriabin/commitment.nvim",
  enabled = true,
  opts = {
    stop_on_write = false,
    writes_number = 150,
  },
}

--   -- Regular message. Shown when writes limit is reached or timer fired.
--   message = "Don't forget to git commit!",
--
--   -- Message shown when writes are prevented.
--   message_write_prevent = "You shall not write!",
--
--   -- Message shown when useless commit message is detected.
--   message_useless_commit = "That's not a very useless commit message, mind rephrasing it?",
--
--   -- Prevents writes to file until changes are committed.
--   stop_on_write = false,
--
--   -- Prevent writes to file when useless commit message is detected.
--   stop_on_useless_commit = false,
--
--   -- Number of writes before asking to commit.
--   writes_number = 30,
--
--   -- Interval in minutes to check git tree for changes.
--   check_interval = -1,
