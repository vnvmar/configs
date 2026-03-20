# ------------------ beg: General ZSH setup ------------------
# ----------- REFERENCES: -----------
# - https://thevaluable.dev/zsh-install-configure-mouseless/
# - https://gist.github.com/elliottminns/09a598082d77f795c88e93f7f73dba61
# - https://www.youtube.com/watch?v=3fVAtaGhUyU&t=2s
# -----------------------------------

bindkey -v
export KEYTIMEOUT=1
export EDITOR=nvim

zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# ----------- bind 'da"' | 'ci(' -----------
autoload -Uz select-bracketed select-quoted
zle -N select-quoted
zle -N select-bracketed
for km in viopp visual; do
  bindkey -M $km -- '-' vi-up-line-or-history
  for c in {a,i}${(s..)^:-\'\"\`\|,./:;=+@}; do
    bindkey -M $km $c select-quoted
  done
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $km $c select-bracketed
  done
done
# -----------------------------------

autoload -U compinit; compinit
autoload zmv

zstyle ':completion:*' matcher-list \
  'm:{a-z}={A-Z}' \
  'm:{A-Z}={a-z}'

setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# ----------- PLUGINS: -----------
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
# -----------------------------------

# ------------------ end: General ZSH setup ------------------

# ------------------ beg: Scripts ------------------

export PATH="$PATH:/$HOME/Scripts"
export PATH="$PATH:/$HOME/.config/zsh"

for script in ~/Scripts/*.zsh(N); do 
    source "$script" 
done

for script in ~/.config/zsh/*.zsh(N); do
    source "$script" 
done

# ------------------ end: Scripts ------------------

hash -d zsh=~/.config/zsh/
hash -d ona=~/Projects/C/ona.h
hash -d proj=~/Projects
hash -d swd=~/Work/softwerk

alias l='eza -la'
alias e='exit'
alias c='cfzf'
alias cf='cdfzf'
alias ch='cdfzf ~/'
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

alias -s json='jless'
alias -s md='bat'
alias -s yaml='bat -l yaml'
alias -s yml='bat -l yaml'
alias -s png='chafa'
alias -s jpg='chafa'
alias -s jpeg='chafa'
alias -s webp='chafa'
alias -s gif='chafa'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias v='nvim +ZenToggle .'
alias vs='nvim $(fzf) -c ":ZenMode"'
alias vi='nvim +ZenToggle'
alias vv='nvim -c "Explore . " -c "term"'
alias vh='nvim -c "Explore . " -c "vertical botright split | term"'

export HOMEBREW_NO_ENV_HINTS=1;

eval "$(starship init zsh)"

function zle-line-init zle-keymap-select()
{
    RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
    RPS2=$RPS1
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select
