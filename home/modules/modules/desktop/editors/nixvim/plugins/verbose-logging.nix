{
  programs.nixvim = {
    extraConfigLuaPre = ''
      -- Verbose error and warning logging
      -- This module captures errors and warnings before plugins fully initialize
      -- Log file: ~/.cache/nvim/notify-errors.log

      local log_dir = vim.fn.expand("~/.cache/nvim")
      local log_file = log_dir .. "/notify-errors.log"

      -- Ensure log directory exists
      vim.fn.mkdir(log_dir, "p")

      -- Function to write to log file
      local function write_to_log(message)
        local file = io.open(log_file, "a")
        if file then
          file:write(message .. "\n")
          file:close()
        end
      end

      -- Function to get current timestamp
      local function get_timestamp()
        return os.date("%Y-%m-%d %H:%M:%S")
      end

      -- Function to get neovim version
      local function get_nvim_version()
        local version = vim.version()
        return string.format("v%d.%d.%d", version.major, version.minor, version.patch)
      end

      -- Function to get loaded plugins/modules at startup
      local function get_loaded_modules()
        local modules = {}
        for name, _ in pairs(package.loaded) do
          if name:match("^[%w%.%-_]+$") and not name:match("^_") then
            table.insert(modules, name)
          end
        end
        table.sort(modules)
        return modules
      end

      -- Write session header
      local separator = "==============================================="
      write_to_log("")
      write_to_log(separator)
      write_to_log("Session started: " .. get_timestamp())
      write_to_log("Neovim version: " .. get_nvim_version())
      write_to_log("")

      -- Log initially loaded modules
      local initial_modules = get_loaded_modules()
      if #initial_modules > 0 then
        write_to_log("Initial loaded modules (" .. #initial_modules .. "):")
        for _, module in ipairs(initial_modules) do
          write_to_log("  - " .. module)
        end
        write_to_log("")
      end

      write_to_log(separator)

      -- Store original vim.notify (which is now a Snacks.notifier module)
      local original_notify_fn = nil

      -- Try to wrap vim.notify immediately (it might not be loaded yet)
      -- Set up a deferred wrapper that will activate when Snacks loads
      local function wrap_snacks_notifier()
        if type(vim.notify) == "table" and vim.notify.notify then
          -- This is Snacks.notifier - wrap it
          if not original_notify_fn then
            original_notify_fn = vim.notify.notify
            vim.notify.notify = function(msg, level, opts)
              -- Only log errors and warnings (levels 0=ERROR, 1=WARN)
              if level ~= nil and (level == vim.log.levels.ERROR or level == vim.log.levels.WARN) then
                local level_str = level == vim.log.levels.ERROR and "ERROR" or "WARN"
                local entry = get_timestamp() .. " [" .. level_str .. "] " .. tostring(msg)
                write_to_log(entry)

                -- Try to capture stack trace for errors
                if level == vim.log.levels.ERROR then
                  local traceback = debug.traceback("", 2)
                  if traceback and traceback ~= "" then
                    local trace_lines = vim.split(traceback, "\n")
                    for i, line in ipairs(trace_lines) do
                      if i > 1 and line ~= "" then
                        write_to_log("    " .. line)
                      end
                    end
                  end
                end
              end
              return original_notify_fn(msg, level, opts)
            end
          end
        end
      end

      -- Try wrapping on VimEnter when plugins have loaded
      vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        callback = function()
          wrap_snacks_notifier()
        end,
      })

      -- Also try wrapping on every notify call until it sticks
      -- This is a fallback for cases where VimEnter is too late
      local wrap_attempts = 0
      local function deferred_wrap()
        wrap_attempts = wrap_attempts + 1
        if wrap_attempts > 100 then
          return  -- Give up after 100 attempts
        end
        wrap_snacks_notifier()
        -- Schedule another attempt if wrapping didn't work
        if not original_notify_fn then
          vim.schedule(deferred_wrap)
        end
      end
      vim.schedule(deferred_wrap)

      -- Store original error handler (if any)
      _G._verbose_logging_errors_captured = {}
    '';
  };
}
