
# ------------- NAVIGATION -------------

hash -d conf=~/.config
hash -d zsh=~/.config/zsh/
hash -d ona=~/Projects/C/ona
hash -d proj=~/Projects

# ------------- work -------------
hash -d swd=~/Work/softwerk
hash -d swf=~/Work/softwerk/framework
hash -d swp=~/Work/softwerk/pipeline

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# ------------- GENERAL -------------

alias l='eza -la'
alias e='exit'
alias ff='cfzf'
alias fd='cdfzf'
alias f='cdfzf ~/'
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

alias v='nvim +ZenToggle .'
alias vs='nvim $(fzf) -c ":ZenMode"'
alias vi='nvim +ZenToggle'
alias vv='nvim -c "Explore . " -c "term"'
alias vh='nvim -c "Explore . " -c "vertical botright split | term"'

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
