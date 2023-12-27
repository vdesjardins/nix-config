local wezterm = require("wezterm")

local exec_domains = {}

-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
local function basename(s)
    return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

function exec_domains.configure(config)
    config.exec_domains = {
        -- Defines a domain called "scoped" that will run the requested
        -- command inside its own individual systemd scope.
        -- This defines a strong boundary for resource control and can
        -- help to avoid OOMs in one pane causing other panes to be
        -- killed.
        wezterm.exec_domain("scoped", function(cmd)
            -- The "cmd" parameter is a SpawnCommand object.
            -- You can log it to see what's inside:
            wezterm.log_info(cmd)

            -- Synthesize a human understandable scope name that is
            -- (reasonably) unique. WEZTERM_PANE is the pane id that
            -- will be used for the newly spawned pane.
            -- WEZTERM_UNIX_SOCKET is associated with the wezterm
            -- process id.
            local env = cmd.set_environment_variables
            local ident = "wezterm-pane-"
                .. env.WEZTERM_PANE
                .. "-on-"
                .. basename(env.WEZTERM_UNIX_SOCKET)

            -- Generate a new argument array that will launch a
            -- program via systemd-run
            local wrapped = {
                "systemd-run",
                "--user",
                "--scope",
                "--description=Shell started by wezterm",
                "--same-dir",
                "--collect",
                "--unit=" .. ident,
            }

            -- Append the requested command
            -- Note that cmd.args may be nil; that indicates that the
            -- default program should be used. Here we're using the
            -- shell defined by the SHELL environment variable.
            for _, arg in ipairs(cmd.args or { os.getenv("SHELL") }) do
                table.insert(wrapped, arg)
            end

            -- replace the requested argument array with our new one
            cmd.args = wrapped

            -- and return the SpawnCommand that we want to execute
            return cmd
        end),
    }

    -- Making the domain the default means that every pane/tab/window
    -- spawned by wezterm will have its own scope
    config.default_domain = "scoped"
end

return exec_domains
