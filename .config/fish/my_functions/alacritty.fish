function alacritty-theme --argument theme
    set -l config_file ~/.config/alacritty/alacritty.yml

    if ! test -f $config_file
      echo "file $config_file doesn't exist"
      return
    end

    # sed doesn't like symlinks, get the absolute path
    set -l config_path (realpath $config_file)
    set -l lazygit_path (realpath ~/.config/lazygit/config.yml)

    sed -i "" -e "s#^colors: \*.*#colors: *$theme#g" $config_path
    sed -i "" -e "s#^lightTheme: \*.*#lightTheme: *true#g" $lazygit_path

    echo "switched to $theme."
end
