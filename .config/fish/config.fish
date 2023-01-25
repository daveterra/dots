###############################################################################
#                                 Fish Config                                 #
###############################################################################
#
# Reference is: https://fishshell.com/docs/current/language.html
#

# Set up homebrew
# set -gx HOMEBREW_PREFIX "/opt/homebrew";
# set -gx HOMEBREW_CELLAR "/opt/homebrew/Cellar";
# set -gx HOMEBREW_REPOSITORY "/opt/homebrew";
# set -q PATH; or set PATH ''; set -gx PATH "/opt/homebrew/bin" "/opt/homebrew/sbin" $PATH;
# set -q MANPATH; or set MANPATH ''; set -gx MANPATH "/opt/homebrew/share/man" $MANPATH;
# set -q INFOPATH; or set INFOPATH ''; set -gx INFOPATH "/opt/homebrew/share/info" $INFOPATH;

# Add to path
fish_add_path "$HOME/.cargo/bin"
fish_add_path /usr/local/sbin
fish_add_path ~/.local/bin
fish_add_path ~/bin/
fish_add_path ~/.cargo/bin

# Helper functions
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

source ~/.config/fish/my_functions/*.fish

set -gx EDITOR nvim

if status is-interactive
  set -gx DEFAULT_USER dave
  set -gx XDG_DATA_HOME "$HOME/.local/share"
  set -gx XDG_CONFIG_HOME "$HOME/.config"

  # Set locations for tools so $HOME isn't clogged up
  set -gx CHTSH_CONF "$XDG_CONFIG_HOME/cht.sh/cht.sh.conf"
  set -gx SD_ROOT "$HOME/bin/sd_scripts/"
  set -gx _ZO_DATA_DIR "$XDG_DATA_HOME/z/"
  set -gx YARN_RC_FILENAME "$XDG_CONFIG_HOME/yarn/yarnrc"
  set -gx WGETRC "$XDG_CONFIG_HOME/wget/wgetrc"

  # Dumb stock stuff
  set -gx ALPHAVANTAGE_API_KEY "D8UNN6TF6CBFUELX"
  function stock -d "Get a quote" -a ticker
    # or use tstock...
    curl "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=$ticker&apikey=$ALPHAVANTAGE_API_KEY"
  end

  function pipupdate -d "Update out of date packages"
    pip list -o | awk 'NR > 2 {print $1}' | xargs pip install -U
  end

  function ls --wraps ls -d "ls with preferred options"
    # command ls --group-directories-first --color=always -F1 "$argv"
    command ls --color=always -F $argv
  end

  function cd -d "cd and then ls"
    builtin cd $argv && ls
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

  # function config --wraps git --description 'An alias for working on dotfiles with git'
    # command git --git-dir=$XDG_DATA_HOME/dots --work-tree=$HOME $argv
  # end

  # Alias
  alias vi nvim
  alias vim nvim
  alias mux tmuxinator
  alias ll "ls -alh"
  alias gap "git add --patch -i"
  alias btc "ssh cointop.sh"
  alias mutt "neomutt -d 5 -l ~/.neomutt.log"
  alias deepthought "ssh dave@10.173.0.2"
  alias truenas "ssh dave@10.173.0.4"
  alias glados "ssh dave@10.173.0.5"
  alias skynet "ssh pi@10.243.24.42"
  alias nas "ssh Dave@10.173.0.3"
  alias cloud "ssh dave@terracloud.us"
  alias router "ssh admin@10.173.0.1"
  alias myip "curl ipinfo.io/ip"
  # https://blog.benoitj.ca/2020-10-03-chezmoi-merging/
  alias cmm="chezmoi diff --use-builtin-diff | grep 'diff --git' | cut -f3 -d ' ' | sed 's/a\//~\//' | xargs -r chezmoi merge"
  abbr rm recycling
  alias config "git --git-dir=$XDG_DATA_HOME/dots --work-tree=$HOME $argv"
  set -U fish_key_bindings fish_vi_key_bindings

  function setcursors
     set -g fish_cursor_default block
     set -g fish_cursor_insert block
     set -g fish_cursor_visual block
  end

  function fish_command_not_found
    if test "$argv[1]" = "fisher"
      curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
    end
    if test "$argv[1]" = "nix-env"
      fisher update
    end
    if test "$argv[1]" = "vf"
      python -m pip install virtualfish
      vf install
      vf addplugins auto_activation
    end

    echo "Dave, check your config.fish"
    __fish_default_command_not_found_handler $argv
  end

  starship init fish | source
end



