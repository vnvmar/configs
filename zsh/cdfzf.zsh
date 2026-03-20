
cfzf() {
  local base sel

  base="${1:-.}"

  sel="$(
    find "$base" \( -type f -o -type d \) -print 2>/dev/null | fzf
  )" || return 0

  [[ -z "$sel" ]] && return 0

  if [[ -d "$sel" ]]; then
    cd "$sel" || return
  elif [[ -f "$sel" ]]; then
    cd "$(dirname "$sel")" || return
  fi
}

cdfzf() {
  local base sel

  base="${1:-.}"

  sel="$(
    find "$base" -type d -print 2>/dev/null | fzf
  )" || return 0

  [[ -n "$sel" ]] && cd "$sel"
}
