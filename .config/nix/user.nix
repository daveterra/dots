with import <nixpkgs> {}; [
  # Command line tools 
  fish
  bash # Needed for tmux/extracto, also just nice to have newer version
  zoxide # replaces cd 
  exa # replaces ls 
  silver-searcher # ag 
  dust
  jq
  tree
  wget
  pv
  tmux
  fzf
  starship
  git
  ripgrep
  aspell
  lazygit
  bitwarden-cli
  docker-compose
  nix
  rsync
  tmuxinator
  fswatch
  nmap
  python310
  inetutils
  # ddgr # duck duck go from
  # mosh # an ssh wrapper
  
  # Fun-like utils
  neofetch
  lolcat
  cowsay
  figlet
  boxes
  asciiquarium
  cbonsai
  # graph-easy

  # Currently disabled
  # spotdl
  # neovim
  # ctags
  # chafa # image viewer

  # Helix and LSPs
  python310Packages.python-lsp-server
  marksman
  helix

  # fun
]
