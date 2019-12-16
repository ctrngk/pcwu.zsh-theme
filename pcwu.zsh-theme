# git:
# %b => current branch
# %a => current action (rebase/merge)
# prompt:
# %F => color dict
# %f => reset color
# %~ => current path
# %c => current dir
# %* => time
# %n => username
# %m => shortname host

function is_ssh() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "%{$fg_bold[red]%}(ssh)%f"
  fi
}

local prefix="%{$fg_bold[white]%}▲"
local dir="%{$fg_bold[blue]%}%c%f"


ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✖"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg_bold[green]%}✔"

# PROMPT='$prefix $dir $(git_prompt_info)'
# add (ssh) in prompt if ssh connected
PROMPT='${prefix}$(is_ssh) ${dir} $(git_prompt_info)'
RPROMPT='%{$fg_bold[white]%}[%*]%f'

# $SECONDS =>  whole seconds the shell has been running
# $exeute_time => the sceonds when execute (or enter)
# $elapsed_time => show elapsed time, default to be 0

local elapsed_time=0

function preexec() {
  execute_time=${execute_time:-$SECONDS}
}

function precmd() {
  if [ $execute_time ]; then
    elapsed_time=$(($SECONDS - $execute_time))
    RPROMPT='%{$fg_bold[red]%}(${elapsed_time}s)%f%{$fg_bold[white]%}[%*]%f'
    unset execute_time
  fi
}


autoload -Uz add-zsh-hook
add-zsh-hook preexec preexec
add-zsh-hook precmd precmd

# immediately update the time stamp if hit enter in terminal
# https://stackoverflow.com/a/35051172/6710360
function _reset-prompt-and-accept-line {
  zle reset-prompt
  zle .accept-line     # Note the . meaning the built-in accept-line.
}
zle -N accept-line _reset-prompt-and-accept-line
