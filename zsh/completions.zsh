
autoload -U compinit; compinit
autoload zmv

zstyle ':completion:*' matcher-list \
  'm:{a-z}={A-Z}' \
  'm:{A-Z}={a-z}'

