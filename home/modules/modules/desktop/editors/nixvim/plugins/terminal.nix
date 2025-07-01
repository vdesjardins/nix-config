{
  programs.nixvim = {
    keymaps = [
      {
        mode = "n";
        key = "<leader>tp";
        action.__raw = "function() Snacks.terminal.open() end";
        options.desc = "Project Directory (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>tb";
        action.__raw = ''function() Snacks.terminal.open(nil, {cwd=tostring(vim.fn.expand("%:p:h"))}) end'';
        options.desc = "Current Buffer Directory (Snacks)";
      }
      {
        mode = "n";
        key = "<leader>tt";
        action.__raw = "function() Snacks.terminal.toggle() end";
        options.desc = "Toggle All Terminals (Snacks)";
      }
      {
        mode = "v";
        key = "<leader>s";
        action.__raw = ''
          function()
            --- @return string[]|nil lines The selected text as an array of lines.
            function get_visual_selection_text()
              local _, srow, scol = unpack(vim.fn.getpos('v'))
              local _, erow, ecol = unpack(vim.fn.getpos('.'))

              -- visual line mode
              if vim.fn.mode() == 'V' then
                if srow > erow then
                  return vim.api.nvim_buf_get_lines(0, erow - 1, srow, true)
                else
                  return vim.api.nvim_buf_get_lines(0, srow - 1, erow, true)
                end
              end

              -- regular visual mode
              if vim.fn.mode() == 'v' then
                if srow < erow or (srow == erow and scol <= ecol) then
                  return vim.api.nvim_buf_get_text(0, srow - 1, scol - 1, erow - 1, ecol, {})
                else
                  return vim.api.nvim_buf_get_text(0, erow - 1, ecol - 1, srow - 1, scol, {})
                end
              end

              -- visual block mode
              if vim.fn.mode() == '\22' then
                local lines = {}
                if srow > erow then
                  srow, erow = erow, srow
                end
                if scol > ecol then
                  scol, ecol = ecol, scol
                end
                for i = srow, erow do
                  table.insert(
                    lines,
                    vim.api.nvim_buf_get_text(0, i - 1, math.min(scol - 1, ecol), i - 1, math.max(scol - 1, ecol), {})[1]
                  )
                end
                return lines
              end
            end

            local text = get_visual_selection_text()
            table.insert(text, "")

            local terminals = Snacks.terminal.list()
            for _, term in ipairs(terminals) do
              local job_id = vim.bo[term.buf].channel
              vim.fn.chansend(job_id, text)
              -- cancel selection
              vim.api.nvim_input('<esc>')
              return
            end
          end
        '';
        options.desc = "Send Selection Terminal (Snacks)";
      }
    ];
  };
}
