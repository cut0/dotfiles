#!/bin/sh
# Claude Code statusLine command
# Format: branch [status_flags] [ahead/behind] | model ctx:N% 5h:N% 7d:N%

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
five_hour_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_day_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
transcript=$(echo "$input" | jq -r '.transcript_path // empty')

# ANSI colors (Gruvbox-inspired)
RESET=$(printf '\033[0m')
BOLD=$(printf '\033[1m')
DIM=$(printf '\033[2m')
RED=$(printf '\033[38;5;167m')      # gruvbox red
GREEN=$(printf '\033[38;5;142m')    # gruvbox green
YELLOW=$(printf '\033[38;5;214m')   # gruvbox yellow
BLUE=$(printf '\033[38;5;109m')     # gruvbox blue
PURPLE=$(printf '\033[38;5;175m')   # gruvbox purple
AQUA=$(printf '\033[38;5;108m')     # gruvbox aqua
GRAY=$(printf '\033[38;5;245m')     # gruvbox gray

# Color a percentage: <50 green / <80 yellow / >=80 red
color_for_pct() {
  n=$(printf '%.0f' "$1" 2>/dev/null || echo 0)
  if [ "$n" -ge 80 ]; then
    printf '%s' "$RED"
  elif [ "$n" -ge 50 ]; then
    printf '%s' "$YELLOW"
  else
    printf '%s' "$GREEN"
  fi
}

# Git branch and status
git_info=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" -c gc.auto=0 symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" -c gc.auto=0 rev-parse --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    status_flags=""
    git_status=$(git -C "$cwd" -c gc.auto=0 status --porcelain 2>/dev/null)
    if echo "$git_status" | grep -q "^??"; then status_flags="${status_flags}?"; fi
    if echo "$git_status" | grep -q "^ M\|^MM\|^ D"; then status_flags="${status_flags}!"; fi
    if echo "$git_status" | grep -q "^M\|^A\|^D\|^R\|^C"; then status_flags="${status_flags}+"; fi
    ahead=$(git -C "$cwd" -c gc.auto=0 rev-list --count @{u}..HEAD 2>/dev/null || echo "")
    behind=$(git -C "$cwd" -c gc.auto=0 rev-list --count HEAD..@{u} 2>/dev/null || echo "")
    ab_flags=""
    if [ -n "$ahead" ] && [ "$ahead" -gt 0 ] 2>/dev/null; then ab_flags="${ab_flags}⇡${ahead}"; fi
    if [ -n "$behind" ] && [ "$behind" -gt 0 ] 2>/dev/null; then ab_flags="${ab_flags}⇣${behind}"; fi

    branch_part="${AQUA}${BOLD}${branch}${RESET}"
    status_part=""
    if [ -n "$status_flags" ]; then
      status_part=" ${YELLOW}${status_flags}${RESET}"
    fi
    ab_part=""
    if [ -n "$ab_flags" ]; then
      ab_part=" ${PURPLE}${ab_flags}${RESET}"
    fi
    git_info="${branch_part}${status_part}${ab_part}"
  fi
fi

# Context usage
ctx_info=""
if [ -n "$used_pct" ]; then
  c=$(color_for_pct "$used_pct")
  ctx_info=" ${GRAY}ctx:${RESET}${c}$(printf '%.0f' "$used_pct")%${RESET}"
fi

# 5-hour rate limit
five_hour_info=""
if [ -n "$five_hour_pct" ]; then
  c=$(color_for_pct "$five_hour_pct")
  five_hour_info=" ${GRAY}5h:${RESET}${c}$(printf '%.0f' "$five_hour_pct")%${RESET}"
fi

# 7-day rate limit
seven_day_info=""
if [ -n "$seven_day_pct" ]; then
  c=$(color_for_pct "$seven_day_pct")
  seven_day_info=" ${GRAY}7d:${RESET}${c}$(printf '%.0f' "$seven_day_pct")%${RESET}"
fi

# Model
model_info=""
if [ -n "$model" ]; then
  model_info=" ${BLUE}${model}${RESET}"
fi

# First user prompt from transcript (truncated to 40 chars)
prompt_info=""
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
  prompt_text=$(head -n 200 "$transcript" 2>/dev/null | jq -rs '
    [.[] | select(.type == "user" and (.message.role // "") == "user")
            | (.message.content
               | if type == "array" then
                   [.[] | select(.type == "text") | .text] | join("\n")
                 else . // "" end)
            | gsub("(?s)<system-reminder>.*?</system-reminder>"; "")
            | gsub("^[\\s\\n]+|[\\s\\n]+$"; "")
            | gsub("[\\n\\r]+"; " ")]
    | map(select(length > 0))
    | .[0] // ""
    | if length > 40 then .[0:40] + "…" else . end
  ' 2>/dev/null)
  if [ -n "$prompt_text" ]; then
    prompt_info=" ${DIM}›${RESET} ${PURPLE}${prompt_text}${RESET}"
  fi
fi

sep=" ${DIM}|${RESET}"
if [ -n "$git_info" ]; then
  printf '%s%s%s%s%s%s%s' "$git_info" "$sep" "$model_info" "$ctx_info" "$five_hour_info" "$seven_day_info" "$prompt_info"
else
  printf '%s%s%s%s%s' "${model_info# }" "$ctx_info" "$five_hour_info" "$seven_day_info" "$prompt_info"
fi
