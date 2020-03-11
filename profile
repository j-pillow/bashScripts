# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# ============================================================================== Tell apple to fuck off with zsh
export BASH_SILENCE_DEPRECATION_WARNING=1

# ============================================================================== If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ============================================================================== History settings
# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000


# ============================================================================== Check the window size after each command 
# If necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize


# ============================================================================== Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


# ============================================================================== Set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi


# ============================================================================== Set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac


# ============================================================================== Coloured prompt stuff
# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi


# ============================================================================== Alias definitions
if [ -f ~/.profile_aliases ]; then
  . ~/.profile_aliases
else
  echo
  echo "No ~/.profile_aliases file found"
  echo
fi


# ============================================================================== Pandora
#pandoraLoc=/Users/james/work/pandora/
#pandoraInt=${pandoraLoc}LArReco/bin/PandoraInterface
#if [ -f $pandoraInt ]; then 
#  export FW_SEARCH_PATH=/Users/james/work/pandora/LArReco/settings:$FW_SEARCH_PATH
#  export FW_SEARCH_PATH=/Users/james/work/pandora/LArMachineLearningData:$FW_SEARCH_PATH
#else
#  echo
#  echo "Pandora location is not set correctly"
#  echo "Currently looking for it at" $pandoraLoc
#  echo "Alternatively, just comment this ection out in the ~/.profile"
#  echo
#fi


# ============================================================================== Programmable completion
# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# ============================================================================== Key bindings to allow smarter history searching
case "$-" in
    *i*) bind '"\e[A": history-search-backward'; bind '"\e[B": history-search-forward';;
    *)   ;;
esac


# ============================================================================== ls colour settings
# If you're having problems with ls and dircolors, you probably need to install gnu ls
eval $(gdircolors -b ~/.dircolors)
export LS_COLORS

# ============================================================================== Setting PATH for Python 2.7
# The original version is saved in .profile.pysave
#PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
#export PATH


# ============================================================================== Setting PATH for Python 3.6
# The original version is saved in .profile.pysave
#PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
#export PATH


# ============================================================================== Root
cernRoot=/Applications/root_v6.20.00/bin/thisroot.sh
if [ -f $cernRoot ]; then 
  . $cernRoot
else
  echo
  echo "Root location is not set correctly"
  echo "Currently looking for it at" $cernRoot
  echo "Alternatively, just comment this section out in the ~/.profile"
  echo
fi


# ============================================================================== Set my kerberos configuration
export KRB5_CONFIG=~/.kerb


# ============================================================================== PS1 Settings
RESET="\[\033[0m\]"
RED="\[\033[01;97m\]"
GREEN="\[$(tput bold)\]\[\033[38;5;45m\]"
BLUE="\[$(tput bold)\]\[\033[01;34m\]"
YELLOW="\[$(tput bold)\]\[\033[38;5;27m\]"
WHITE="\[$(tput bold)\]\[\033[01;26m\]"

PS_LINE=`printf -- '- %.0s' {1..200}`
function parse_git_branch {
  PS_BRANCH=''
  PS_FILL=${PS_LINE:0:$COLUMNS}
  if [ -d .svn ]; then
    PS_BRANCH="(svn r$(svn info|awk '/Revision/{print $2}'))"
    return
  elif [ -f _FOSSIL_ -o -f .fslckout ]; then
    PS_BRANCH="(fossil $(fossil status|awk '/tags/{print $2}')) "
    return
  fi
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  PS_BRANCH="(git ${ref#refs/heads/}) "
}

ME=James
PROMPT_COMMAND=parse_git_branch
PS_INFO="$GREEN\w"
PS_GIT="$YELLOW\$PS_BRANCH"
#PS_TIME="\[\033[\$((COLUMNS-10))G\]    $RED[\A\[$(tput sgr0)\]$RED]"
#export PS1="$BLUE$ME ${PS_INFO} ${PS_GIT}${PS_TIME}\n$GREEN\$${RESET} "
#export PS1="$BLUE$ME ${PS_INFO} ${PS_GIT}\n$GREEN\$${RESET} "
export PS1="${BLUE}Macmini ${PS_INFO} ${PS_GIT}\n$GREEN\$${RESET} "

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

