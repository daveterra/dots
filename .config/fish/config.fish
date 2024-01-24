###############################################################################
#                                 Fish Config                                 #
###############################################################################
#
# Reference is: https://fishshell.com/docs/current/language.html
#

set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8
set -gx LANGUAGE en_US.UTF-8
set -gx LOCALE_ARCHIVE /usr/lib/locale/locale-archive
set -gx SHELL (which fish)
# set -gx CONFIG_SHELL (which fish)

# Safer (but more annoying?) rm
function recycling -d "My rm replacement"
  mkdir -p ~/.trash 1>&2 2> /dev/null
  set CURRENTDIR (pwd)
  for file in $argv
      set base (basename $file)
      set dest ~/.trash/$base(date +%m%d%H%M)
      echo "$file -> $dest"
      mv "$file" "$dest"
  end
end

function setDarkMode --argument darkmode
  for file in (/bin/ls /tmp/mykitty*)
    alias kitty /Applications/kitty.app/Contents/MacOS/kitty
    if $darkmode
      echo "Darkmode is on: $file" > /tmp/hello.txt
      kitty @ --to "unix:$file" set-colors -a -c ~/.config/kitty/colors/dark.conf > /tmp/out.txt 2> /tmp/out.txt
    else
      echo "Darkmode is off: $file" > /tmp/hello.txt
      kitty @ --to "unix:$file" set-colors -a -c ~/.config/kitty/colors/light.conf > /tmp/out.txt 2> /tmp/out.txt
    end
  end
end

# Set up for SD
set -gx SD_ROOT "$HOME/code/sd_scripts/"
fish_add_path "$HOME/code/sd"
set -gx EDITOR hx

if status is-interactive
  set -gx DEFAULT_USER dave
  set -gx XDG_DATA_HOME "$HOME/.local/share"
  set -gx XDG_CONFIG_HOME "$HOME/.config"

  # Set locations for tools so $HOME isn't clogged up
  set -gx CHTSH_CONF "$XDG_CONFIG_HOME/cht.sh/cht.sh.conf"
  set -gx _ZO_DATA_DIR "$XDG_DATA_HOME/z/"
  set -gx YARN_RC_FILENAME "$XDG_CONFIG_HOME/yarn/yarnrc"
  set -gx WGETRC "$XDG_CONFIG_HOME/wget/wgetrc"

  # For tmux history search
  set -U FZF_CTRL_R_OPTS "--reverse"
  set -U FZF_TMUX_OPTS "-p" 

  function pipupdate -d "Update out of date packages"
    pip list -o | awk 'NR > 2 {print $1}' | xargs pip install -U
  end

  function nix-fish
    nix-shell --command "fish"
  end

  function lk
    set loc (walk --icons $argv); and cd $loc;
  end

  # bind \t complete
  # bind \t forward-word
  # bind \t complete-no-pager
  # bind \t cancel
  # bind \t forward-word complete

  # Changes:
  # * Instead of overriding cd, we detect directory change. 
  #   This allows the script to work for other means of cd, such as z.
  # * Update syntax to work with new versions of fish.
  # * Handle virtualenvs that are not located in the root of a git directory.
  function __auto_source_venv --on-variable PWD --description "Activate/Deactivate virtualenv on directory change"
    status --is-command-substitution; and return

    # Check if we are inside a git directory
    if git rev-parse --show-toplevel &>/dev/null
      set gitdir (realpath (git rev-parse --show-toplevel))
      set cwd (pwd)
      # While we are still inside the git directory, find the closest
      # virtualenv starting from the current directory.
      while string match "$gitdir*" "$cwd" &>/dev/null
        if count $cwd/.venv**activate.fish &>/dev/null
          source $cwd/.venv**activate.fish &>/dev/null
          return
        else
          set cwd (path dirname "$cwd")
        end
      end
    end
    # If virtualenv activated but we are not in a git directory, deactivate.
    if test -n "$VIRTUAL_ENV"
      deactivate
    end
  end

  function auto_shell_hook --on-variable shellHook
    if test -n "$shellHook" #only if set
      eval $shellHook
    end
  end

  function ls --wraps ls -d "ls with preferred options"
    # command ls --group-directories-first --color=always -F1 "$argv"
    command eza -a  --icons --group-directories-first $argv
  end

  function please -d "Run the last command as sudo"
      eval command sudo $history[1]
  end

  function gjc -d "Git, just commit already!"
      set msg ""
      set REPLY ""
      echo
      while test $REPLY != y
          set msg (curl -s http://whatthecommit.com/index.txt)
          set REPLY (read -P "$msg" -n 1)
          echo
      end
      git commit -m "$msg" && git push
  end

  function cheat.sh
      curl cheat.sh/$argv
  end
  alias cheat cheat.sh

  # Alias
  alias top btop
  alias vi hx 
  alias vim hx 
  alias ll "ls -alh"
  alias gap "git add --patch -i"
  # alias btc "ssh cointop.sh"
  alias mutt "neomutt -d 5 -l ~/.neomutt.log"
  alias deepthought "ssh dave@10.173.0.2"
  alias truenas "ssh dave@10.173.0.4"
  alias glados "ssh dave@10.173.0.5"
  alias work "ssh dave@10.173.0.11"
  alias skynet "ssh pi@10.243.24.42"
  alias cloud "ssh dave@terracloud.us"
  alias router "ssh admin@10.173.0.1"
  alias myip "curl ipinfo.io/ip"
  alias notes "cd ~/Notes && hx ."

  alias config "git --git-dir=$XDG_DATA_HOME/dots --work-tree=$HOME $argv"
  set -U fish_key_bindings fish_vi_key_bindings

  abbr rm recycling
  abbr mux tmuxinator

  set -g fish_cursor_default underscore
  set -g fish_cursor_insert line
  set -g fish_cursor_visual block

  # complete -e cd
  zoxide init --cmd cd fish | source

  function fish_command_not_found
    if test "$argv[1]" = "fisher"
      curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
    else if test "$argv[1]" = "nix-env"
      fisher update
    else if test "$argv[1]" = "vf"
      python -m pip install virtualfish
      vf install
      vf addplugins auto_activation
    else if test "$argv[1]" = "sd"
      git clone  git@github.com:daveterra/sd.git ~/code/sd
      git clone  git@github.com:daveterra/sd_scripts.git ~/code/sd_scripts
    end

    echo "Dave, check your config.fish"
    __fish_default_command_not_found_handler $argv
  end

  starship init fish | source
  direnv hook fish | source

  # If this is an ssh client, cd to terracloud...
  if set -q SSH_CLIENT ;
    cd ~/code/terracloud
  end

  __auto_source_venv
end



