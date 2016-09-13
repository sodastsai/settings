# Colors ---------------------------------------------------------------------------------------------------------------
        RED="\[\033[0;31m\]"
     YELLOW="\[\033[1;33m\]"
      GREEN="\[\033[0;32m\]"
       BLUE="\[\033[1;34m\]"
  LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
      WHITE="\[\033[1;37m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
 COLOR_NONE="\[\e[0m\]"

# Aliases --------------------------------------------------------------------------------------------------------------
alias ls='ls -hG'
alias ll='ls -l'
alias lll='ls -al'
alias vi='vim'

# Functions ------------------------------------------------------------------------------------------------------------
randomHex() {
    LEN=${1:-32}
    python -c "import base64,math,os;print(base64.b16encode(os.urandom(int(math.ceil(${LEN}/2.0)))).decode(\"utf-8\").lower()[:${LEN}])"
}
alias random64Hex='randomHex 64'

uuid() {
    python -c "import uuid; print(uuid.uuid4())"
}

lockScreen() {
    /System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend
}

# Git ------------------------------------------------------------------------------------------------------------------
source ~/.git-completion.bash

# AWS ------------------------------------------------------------------------------------------------------------------
complete -C aws_completer aws

# Swift ----------------------------------------------------------------------------------------------------------------
eval "$(swiftenv init -)"

# Python ---------------------------------------------------------------------------------------------------------------
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
unset PYENV_VIRTUALENV_VERBOSE_ACTIVATE

# PS1 ------------------------------------------------------------------------------------------------------------------
function set_bash_prompt() {
  PS1_PREFIX=""
  PS1_INFO=""
  # Git Branch
  CURRENT_GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [[ "${CURRENT_GIT_BRANCH}" ]]; then
    PS1_INFO="${PS1_INFO}(git: ${CURRENT_GIT_BRANCH}) "
  fi

  # Python virtualenv
  PYENV_VIRTUALENV=`pyenv local 2>/dev/null`
  if [[ $? == 0 ]]; then
    PS1_INFO="${PS1_INFO}(python: ${PYENV_VIRTUALENV}) "
  elif [[ "${VIRTUAL_ENV}" ]]; then
    PS1_INFO="${PS1_INFO}(python: $(basename ${VIRTUAL_ENV})) "
  fi

  # SSH
  if [[ "${SSH_CLIENT}" ]]; then
    PS1_PREFIX="<ssh>"
  fi

  # Set the bash prompt variable.
  if [[ "${PS1_INFO}" ]]; then
    PS1_INFO="${LIGHT_GRAY}>>> ${PS1_INFO}${COLOR_NONE}\n"
  fi
  if [[ "${PS1_PREFIX}" ]]; then
    PS1_PREFIX="${LIGHT_GRAY}${PS1_PREFIX}${COLOR_NONE} "
  fi
  PS1="${PS1_INFO}${PS1_PREFIX}\h:\W \u\$ "
}
PROMPT_COMMAND="${PROMPT_COMMAND};set_bash_prompt"
PROMPT_COMMAND=`echo $PROMPT_COMMAND | sed 's/;\{2,\}/;/'`
