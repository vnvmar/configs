
# ------------------- REFERENCE -------------------
# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh
# ------------------- REFERENCE -------------------

alias gis="git status"
alias cis="clear && clear && git status"

# ------------------- beg: stagin -------------------
alias ga="git add"
alias gaa="git add --all"
# ------------------- end: staging -------------------

# ------------------- beg: commit -------------------
alias gc="git commit"
alias gcm="git commit -m"
alias gcam="git commit --all -m"
alias gc!="git commit --amend --no-edit --no-verify"
# ------------------- end: commit -------------------

# ------------------- beg: pushing -------------------
alias gp="git push"
alias gpo="git push origin"
# ------------------- end: pushing -------------------

# ------------------- beg: pulling -------------------
alias gl="git pull"
alias glr="git pull --rebase"
# ------------------- end: pulling -------------------

# ------------------- beg: log -------------------
alias glo="git log --pretty='oneline'"
alias glog="git log --graph --oneline --decorate"
alias clog="clear && clear && git log --graph --oneline --decorate"
# ------------------- end: log -------------------

# ------------------- beg: checking out & branches -------------------
alias gco="git checkout"
alias gcb="git checkout -b"
alias gb="git branch"
alias gbc="git rev-parse --abbrev-ref HEAD"
alias gsw="git switch"
alias gswh="git switch -"
# ------------------- end: checking out & branches -------------------

# ------------------- beg: diffs -------------------
alias gd="git diff"
alias gda="git diff --apply"
alias gdaw="git apply --whitespace=fix"
gdla() 
{
    git add --intent-to-add --all && git diff && git reset >/dev/null
}
gdl() 
{
    git add --intent-to-add "$@" && git diff "$@" && git reset "$@" >/dev/null
}
# ------------------- end: diffs -------------------

# ------------------- beg: restore -------------------
alias gr="git restore"
alias grs="git restore --staged ."
alias gra="git clean -d -f && git restore ."
alias gru="git clean -d -f"
# ------------------- end: restore -------------------


gwtam()
{
    git worktree add "$1" && cd "$1" && git pull
}

gwtrm()
{
    git worktree remove --force "$1" && git branch -D "$1"
}
