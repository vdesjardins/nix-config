{
  pkgs,
  my-packages,
  ...
}: let
  clip-copy =
    if pkgs.stdenv.isDarwin
    then "pbcopy"
    else "${pkgs.wl-clipboard}/bin/wl-copy -n";
in ''
  # extra

  # force a reload of the config file
  unbind-key r
  bind-key -N "Reload config file" r source-file ~/.config/tmux/tmux.conf \; run-shell "sleep 0.1" \; refresh-client -S

  # Setup 'v' to begin selection as in Vim
  bind-key -T edit-mode-vi Up send-keys -X history-up
  bind-key -T edit-mode-vi Down send-keys -X history-down
  unbind-key -T copy-mode-vi Space     ;   bind-key -T copy-mode-vi v   send-keys -X begin-selection
  unbind-key -T copy-mode-vi Enter     ;   bind-key -T copy-mode-vi y   send-keys -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"
  unbind-key -T copy-mode-vi C-v       ;   bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
  unbind-key -T copy-mode-vi [         ;   bind-key -T copy-mode-vi [   send-keys -X begin-selection
  unbind-key -T copy-mode-vi ]         ;   bind-key -T copy-mode-vi ]   send-keys -X copy-selection

  # update environment variables
  set-option -g update-environment "SSH_ASKPASS SSH_AUTH_SOCK SSH_AGENT_PID SSH_CONNECTION DISPLAY"

  # color and italics
  ${
    if pkgs.stdenv.isDarwin
    then ''
      set-option -g default-terminal "xterm-256color"
    ''
    else ''
      set-option -g default-terminal "tmux-256color"
    ''
  }

  # quick view of processes
  bind -N "Exec htop" '~' split-window "exec htop"
  bind -N "Man page" 'K' command-prompt -p "Man:" "split-window 'man %%'"

  # All kind of nice options
  set-option -g   bell-action any
  set-option -g   repeat-time 500
  set-option -g   visual-activity off
  set-option -g   visual-bell off
  set-option -g   visual-silence on
  set-option -g   set-titles on
  set-option -g   set-titles-string ' #I-#W '
  set-option -g   display-time 1500
  set-option -g   renumber-windows on
  set-option -g   set-clipboard on

  # Window
  bind-key -N "Last Window" b last-window

  # Window options
  set-window-option -g clock-mode-colour blue
  set-window-option -g monitor-activity on
  set-window-option -g xterm-keys on
  set-window-option -g automatic-rename on

  # quick pane cycling
  unbind ^A
  bind ^A select-pane -t :.+

  # Pane
  unbind-key l
  bind-key h select-pane -L
  bind-key j select-pane -D
  bind-key k select-pane -U
  bind-key l select-pane -R

  # Smart pane switching with awareness of Vim splits.
  # See: https://github.com/christoomey/vim-tmux-navigator
  is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
      | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
  bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h' 'select-pane -L'
  bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j' 'select-pane -D'
  bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k' 'select-pane -U'
  bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l' 'select-pane -R'
  bind-key -n 'C-\' if-shell "$is_vim" 'send-keys C-\\' 'select-pane -l'

  bind-key -n M-h if-shell "$is_vim" 'send-keys M-h' 'resize-pane -L 3'
  bind-key -n M-j if-shell "$is_vim" 'send-keys M-j' 'resize-pane -D 3'
  bind-key -n M-k if-shell "$is_vim" 'send-keys M-k' 'resize-pane -U 3'
  bind-key -n M-l if-shell "$is_vim" 'send-keys M-l' 'resize-pane -R 3'

  bind-key -T copy-mode-vi 'C-h' select-pane -L
  bind-key -T copy-mode-vi 'C-j' select-pane -D
  bind-key -T copy-mode-vi 'C-k' select-pane -U
  bind-key -T copy-mode-vi 'C-l' select-pane -R
  bind-key -T copy-mode-vi 'C-\' select-pane -l

  # clear screen and history
  bind-key -N "Clear screen and history" BSpace "send-keys -R C-l \; clear-history"

  # use "v" and "s" to do vertical/horizontal splits, like vim
  bind-key -N "New window" c new-window -c '#{pane_current_path}'
  bind-key -N "Split window vertically" s split-window -v -c '#{pane_current_path}'
  bind-key -N "Split window horizontally" v split-window -h -c '#{pane_current_path}'

  # use vim resize keys with submode.
  bind-key -N "Pane resize with vim keys" Z switch-client -T RESIZE

  bind-key -T RESIZE k resize-pane -U \; switch-client -T RESIZE
  bind-key -T RESIZE j resize-pane -D \; switch-client -T RESIZE
  bind-key -T RESIZE h resize-pane -L \; switch-client -T RESIZE
  bind-key -T RESIZE l resize-pane -R \; switch-client -T RESIZE

  bind-key -T RESIZE K resize-pane -U 5 \; switch-client -T RESIZE
  bind-key -T RESIZE J resize-pane -D 5 \; switch-client -T RESIZE
  bind-key -T RESIZE H resize-pane -L 5 \; switch-client -T RESIZE
  bind-key -T RESIZE L resize-pane -R 5 \; switch-client -T RESIZE

  # join a pane to the current window.
  bind-key -N "Join a pane to current window" J command-prompt -p "Window to join to this one:" "join-pane -s %%"

  # session
  bind-key -N "Choose session" S choose-session
  bind-key -N "Create and name new session" u command-prompt -p "Name your new session:" "new-session -s %%"

  # be able to copy/paste `
  bind-key -n F11 set -g prefix `
  bind-key -n F12 set -g prefix C-o

  # save history buffer to file
  bind-key -N "Save history buffer to file" P command-prompt -p 'save history to filename:' -I '~/tmux.history' 'capture-pane -S -100000; save-buffer %1 ; delete-buffer'

  # focus events
  set-option -g focus-events on

  # toggle mouse
  unbind m
  bind-key -N "Mouse ON" m \
    set-option -g mouse on \;\
    display 'Mouse: ON'

  unbind M
  bind-key -N "Mouse OFF" M \
    set-option -g mouse off \;\
    display 'Mouse: OFF'

  # copy to system keyboard
  # bind-key S-y run-shell "tmux show-buffer | ${clip-copy}" \; display-message "Copied tmux buffer to system clipboard"

  # automatic window renaming
  set-option -g status-interval 5
  set-option -g automatic-rename on
  set-option -g automatic-rename-format "#{b:pane_current_path}"

  set-option -ga terminal-overrides ",xterm-256color:Tc"
  set-option -ga terminal-overrides ",tmux-256color:Tc"

  # to display image from yazi
  set -g allow-passthrough on

  # [theme]
  set -g @theme_variation 'storm'

  # [fingers]
  set -g @fingers-key Space
''
