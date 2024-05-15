SCRIPT_DIR=$(realpath "${BASH_SOURCE[0]}" | xargs dirname)
rm -r "$HOME/.config/nvim"
ln -s "$SCRIPT_DIR" "$HOME/.config/nvim"
