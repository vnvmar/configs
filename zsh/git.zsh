
# ------------------- REFERENCE -------------------
# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh
# ------------------- REFERENCE -------------------

alias gis="git status"

# ------------------- beg: stagin -------------------
alias ga="git add"
alias gaa="git add --all"
# ------------------- end: staging -------------------

# ------------------- beg: commit -------------------
alias gc="git commit"
alias gcm="git commit -m"
alias gcam="git commit --all -m"
alias gc!="git commit --amend --no-edit"
# ------------------- end: commit -------------------

# ------------------- beg: pushing -------------------
alias gp="git push"
alias gpo="git push origin"
# ------------------- end: pushing -------------------

# ------------------- beg: pulling -------------------
alias gl="git pull --no-rebase"
# ------------------- end: pulling -------------------

# ------------------- beg: log -------------------
alias glo="git log --pretty='oneline'"
alias glog="git log --graph --oneline --decorate"
# ------------------- end: log -------------------

# ------------------- beg: checking out & branches -------------------
alias gco="git checkout"
alias gcb="git checkout -b"
alias gb="git branch"
# ------------------- end: checking out & branches -------------------

# ------------------- beg: diffs -------------------
alias gd="git diff"
alias gda="git diff --apply"
# ------------------- end: diffs -------------------



gwtam()
{
    git worktree add "$1" && cd "$1" && git pull
}

#gwtrm()
#{
#    git worktree remove "$1" && git branch -D "$1"
#}

