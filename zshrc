bindkey -v

autoload -Uz compinit promptinit
compinit -d $HOME/.cache/zcompdump
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
[[ -n "^J" ]] && bindkey -- "^J" down-line-or-beginning-search

# Get elements of an previous command
bindkey -- "^Y" insert-last-word

# autoload -Uz push-line-or-edit
# zle -N push-line-or-edit
bindkey -- "^A" push-line-or-edit

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -- "^X^E" edit-command-line

prompt='%B%F{red}%2~ $ %f%b'

# Allow termite to open a new terminal in the cwd
if [[ $TERM == xterm-termite ]]; then
  . /etc/profile.d/vte.sh
  __vte_osc7
fi

function vim_and_clear {
	\vim $@
	clear
}

function vim_help {
	nvim -c ":h $1 | only"
}

# TODO
# echo usage if $# < 3
function vert_append {
  if [ $# = 0 ]; then
    echo "Usage: $0 input_file1, input_file2, ..., output_file"
  else
    convert -append $@
  fi
}

function hor_append {
  if [ $# = 0 ]; then
    echo "Usage: $0 input_file1, input_file2, ..., output_file"
  else
    convert +append $@
  fi
}

function better_md2html {
  if [ $# != 2 ] || ! [[ $1 =~ '\.md$' ]] || ! [[ $2 =~ '\.html$' ]] ; then
    echo "Usage: $0 inputfile.md outputfile.html"
  else
    echo '<head> <style type="text/css">body{margin:40px auto;max-width:650px;line-height:1.6;font-size:18px;color:#444;padding:0 10px}h1,h2,h3{line-height:1.2}</style> </head>' > $2
    echo '<body>' >> $2
    md2html $1 >> $2
    echo '</body>' >> $2
  fi
}

function quick_ff {
  html_name=$(mktemp --suffix='.html')
  better_md2html $1 $html_name
  firefox $html_name
  sleep 10
  rm $html_name
}

function mkv2mp4 {
  if [ $# != 1 ] || ! [[ $1 =~ '\.mkv$' ]] ; then
    echo "Usage: $0 file.mkv"
  else
    ffmpeg -i $1 -codec copy "$(echo "$1" | cut -f 1 -d '.')".mp4
  fi
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

# HISTORY
HISTSIZE=1000
SAVEHIST=10000
HISTFILE=~/.history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE

# GLOBBING
setopt GLOBSTARSHORT
setopt GLOB_STAR_SHORT

function start_counter {
	date1=`date +%s`; while true; do
	echo -ne "$(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r";
	done
}

function regroup {
	[ ! -d "$1" ] && mkdir "$1"
	mv $(fd -t f -d 1 "$1") "$1"/
}

mvln() {
  realpathsrc=$(realpath $1)
  mv -i $1 $2
  if [ -d $2 ]
  then
    realpathdst=$(realpath $2)/$(basename $1)
  else
    realpathdst=$(realpath $2)
  fi
  ln -s $realpathdst $realpathsrc
}

source $HOME/.profile
source $HOME/.alias

if [[ "$(tty)" = "/dev/tty1" ]]; then
	pgrep i3 || startx >& ~/.xsession.log
fi

# function ps_wrapper {
# 	tmpfile=$(mktemp)
# 	ps $@ > $tmpfile
# 	head -n 1 $tmpfile >> /dev/tty
# 	head -n 1 $tmpfile
# 	cat $tmpfile
# 	rm $tmpfile
# }

[ -f ~/.fzf/fzf.zsh ] && source ~/.fzf/fzf.zsh

# Completion stuff

compdef _bt bt
function _bt {
	subcmds=('pods' 'speaker' 'disconnect')
	_describe 'command' subcmds
}

setopt COMPLETE_ALIASES
binary_format=('*.o', '*.pdf', '*.mkv', '*.mp3', '*.mp4', '*.jpg', '*.png')
zstyle ':completion:*:*:vim:*:*files' ignored-patterns $binary_format
zstyle ':completion:*:*:v:*:*files' ignored-patterns $binary_format

# Forschungspraktikum
# From https://stackoverflow.com/questions/17051123/source-a-file-in-zsh-when-entering-a-directory
autoload -U add-zsh-hook
ros_sourced=false;
load-local-conf() {
  if [ $ros_sourced = false ]; then
    if [[ $PWD =~ ".*Forschungspraktikum.*"
      && -f $HOME/TUD_WiSe2020/Forschungspraktikum/ros2/install/local_setup.zsh
      && -r $HOME/TUD_WiSe2020/Forschungspraktikum/ros2/install/local_setup.zsh ]];
    then
      export QT_QPA_PLATFORMTHEME=qt5ct
      . $HOME/TUD_WiSe2020/Forschungspraktikum/ros2/install/local_setup.zsh \
        && . $HOME/.local/share/colcon_cd/function/colcon_cd.sh \
        && ros_sourced=true
    fi
  fi
}
add-zsh-hook chpwd load-local-conf

}
