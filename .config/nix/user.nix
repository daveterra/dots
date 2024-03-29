with import <nixpkgs> {}; [
  # Command line tools 
  fish
  bash # Needed for tmux/extracto, also just nice to have newer version
  zoxide # replaces cd 
  eza # replaces ls 
  silver-searcher # ag 
  ncdu # Better du -csh
  walk # Util for browsing folders
  entr # Do something when files change
  restic # Backup util
  jq # Json tool
  btop # Fancier top with disk and net usage
  tree
  wget
  pv
  tmux
  fzf
  starship
  git
  ripgrep
  aspell
  ltex-ls
  aspellDicts.en
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
  flavours
  base16-builder
  direnv
  git-crypt
  walk
  direnv

  # ddgr # duck duck go from terminal
  # mosh # an ssh wrapper
  
  # Fun-like utils
  neofetch
  lolcat
  cowsay
  figlet
  # boxes
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
  nodePackages_latest.vscode-langservers-extracted
  nodePackages_latest.bash-language-server
  swift-format
  typos
  rnix-lsp
  marksman
  helix

  # Other dev, though this should all be local...
  nodejs
  yarn
  arduino-cli
  
  # fun
]
