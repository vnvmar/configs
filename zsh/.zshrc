# ----------- REFERENCES: -----------
# - https://thevaluable.dev/zsh-install-configure-mouseless/
# - https://gist.github.com/elliottminns/09a598082d77f795c88e93f7f73dba61
# - https://www.youtube.com/watch?v=3fVAtaGhUyU&t=2s
# - https://github.com/Phantas0s/.dotfiles/blob/master/zsh/completion.zsh
# -----------------------------------

# ------------------ beg: General ZSH setup ------------------
[[ "$OSTYPE" == "darwin"* ]] && printf '\33c\e[3J' # Disable login message
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
# ------------------ end: General ZSH setup ------------------

# ------------------ beg: Plugins ------------------
source $HOME/configs/zsh/deps/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/configs/zsh/deps/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
FPATH=$HOME/configs/zsh/deps/share/zsh-completions:$FPATH
# ------------------ end: Plugins ------------------

# ------------------ beg: Scripts ------------------

export PATH="$PATH:/$HOME/Scripts"
export PATH="$PATH:/$HOME/configs/zsh"

for script in ~/Scripts/*.zsh(N); do 
    source "$script" 
done

for script in ~/configs/zsh/*.zsh(N); do
    source "$script" 
done

# ------------------ end: Scripts ------------------

export HOMEBREW_NO_ENV_HINTS=1;

eval "$(starship init zsh)"

# --------------------------------------------------
# Somehow fixes conflict between vimmode and starship
# --------------------------------------------------
function zle-line-init zle-keymap-select()
{
    RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
    RPS2=$RPS1
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select
# --------------------------------------------------
