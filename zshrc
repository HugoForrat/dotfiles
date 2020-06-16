bindkey -v

autoload -Uz compinit promptinit
compinit
promptinit

# Arrow-key driven interface for auto-completion
zstyle ':completion:*' menu select

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[ShiftTab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"      beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"       end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"    overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}" backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"    delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"        up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"      down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"      backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"     forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"    beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"  end-of-buffer-or-history
[[ -n "${key[ShiftTab]}"  ]] && bindkey -- "${key[ShiftTab]}"  reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start {
		echoti smkx
	}
	function zle_application_mode_stop {
		echoti rmkx
	}
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# Only the matching past commands are shown when searching the history
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search
[[ -n "^K" ]] && bindkey -- "^K" up-line-or-beginning-search
[[ -n "^J" ]] && bindkey -- "^J" up-line-or-beginning-search

# Get elements of an previous command
bindkey -- "^Y" insert-last-word

# autoload -Uz push-line-or-edit
# zle -N push-line-or-edit
bindkey -- "^A" push-line-or-edit

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -- "^X^E" edit-command-line

prompt='%B%F{red}%2~ %# %f%b'

function vim_and_clear {
	\vim $@
	clear
}

function vim_help {
	vim -c ":h $1 | only"
}

# Snippet from https://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
# Typical use: press ^Z in Vim to go back to the shell
# then press ^Z in the Shell to go back to Vim
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

HISTSIZE=1000
SAVEHIST=2000
HISTFILE=~/.history

function start_counter {
	date1=`date +%s`; while true; do
	echo -ne "$(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r";
	done
}

function regroup {
	[ ! -d "$1" ] && mkdir "$1"
	mv $(fd -t f -d 1 "$1") "$1"/
}

source /home/hugo/.profile
source /home/hugo/.alias

# fzf-tab from
# https://github.com/Aloxaf/fzf-tab
source /home/hugo/.fzf/fzf-tab/fzf-tab.plugin.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [[ "$(tty)" = "/dev/tty1" ]]; then
	pgrep dwm || startx >& ~/.xsession.log
fi
