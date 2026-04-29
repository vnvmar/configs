
# ------------- NAVIGATION -------------

hash -d conf=~/configs
hash -d zsh=~/configs/zsh/

# ------------- work -------------
hash -d fnx=~/Work/fortnox
hash -d fna=~/Work/autogiro
hash -d fnp=~/Work/prototype

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# ------------- GENERAL -------------

alias l='eza -la'
alias e='exit'
alias ff='cdfzf ~/'
alias F='cdfzf'
alias f='cfzf'
alias d='dirs -v'
alias c='clear && clear'
alias k='clear && clear && cd'
alias clip='xclip -selection clipboard'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

alias v='nvim +ZenToggle .'
alias vs='nvim $(fzf) -c ":ZenMode"'
alias vi='nvim +ZenToggle'
alias vv='nvim -c "Explore . " -c "term"'
alias vh='nvim -c "Explore . " -c "vertical botright split | term"'

alias uvc='uv cache clean && rm -rf .venv && rm uv.lock'
alias uvs='uv sync && source .venv/bin/activate'
alias uvcs='uv cache clean && rm -rf .venv && rm uv.lock && uv sync && source .venv/bin/activate'

# ------------- SUFFIX ALIASES -------------

alias -s json='jless'
alias -s md='bat'
alias -s yaml='bat -l yaml'
alias -s yml='bat -l yaml'
alias -s png='chafa'
alias -s jpg='chafa'
alias -s jpeg='chafa'
alias -s webp='chafa'
alias -s gif='chafa'
