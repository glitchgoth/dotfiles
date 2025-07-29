#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
		PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
	else
		PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
	fi

	alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi

unset use_color safe_term match_lhs sh

#alias cp="cp -i"                          # confirm before overwriting something
#alias df='df -h'                          # human-readable sizes
#alias free='free -m'                      # show sizes in MB
#alias np='nano -w PKGBUILD'
#alias more=less

xhost +local:root > /dev/null 2>&1

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases

# export QT_SELECT=4

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

# Color for manpages in less makes manpages a little easier to read
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

#######################################################
# MACHINE SPECIFIC ALIASES
#######################################################

# Aliases for SSH
# alias SERVERNAME='ssh YOURWEBSITE.com -l USERNAME -p PORTNUMBERHERE'

# Aliases to change the directory
alias web='cd /var/www/html'

# Aliases to mount ISO files
# mount -o loop /home/NAMEOFISO.iso /home/ISOMOUNTDIR/
# umount /home/NAMEOFISO.iso
# (Both commands done as root only.)

#######################################################
# GENERAL ALIASES
#######################################################

# Edit this .bashrc file
alias ebrc='edit ~/.bashrc'

# Show help for this .bashrc file
alias hlp='less ~/.bashrc_help'

# alias to show the date
# alias da='date "+%Y-%m-%d %A %T %Z"'

# Aliases to modified commands
alias cp='cp -i'
alias mv='mv -i'
alias rm='trash -v'
#alias mkdir='mkdir -p'
#alias ps='ps auxf'
#alias ping='ping -c 10'
#alias less='less -R'
alias cls='clear'
#alias multitail='multitail --no-repeat -c'
#alias freshclam='sudo freshclam'
#alias svi='sudo vi'

# cd into the old directory
alias bd='cd "$OLDPWD"'

# Remove a directory and all files
alias rmd='/bin/rm  --recursive --force --verbose '


# Aliases for multiple directory listing commands
alias la='ls -Alh'                # show hidden files
#alias ls='ls -aFh --color=always' # add colors and file type extensions
alias lx='ls -lXBh'               # sort by extension
alias lk='ls -lSrh'               # sort by size
alias lc='ls -ltcrh'              # sort by change time
alias lu='ls -lturh'              # sort by access time
alias lr='ls -lRh'                # recursive ls
alias lt='ls -ltrh'               # sort by date
alias lm='ls -alh |more'          # pipe through 'more'
alias lw='ls -xAh'                # wide listing format
alias ll='ls -Fls'                # long listing format
alias labc='ls -lap'              # alphabetical sort
alias lf="ls -l | egrep -v '^d'"  # files only
alias ldir="ls -l | egrep '^d'"   # directories only
alias lla='ls -Al'                # List and Hidden Files
alias las='ls -A'                 # Hidden Files
alias lls='ls -l'                 # List


# alias chmod commands
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

#######################################################
# SPECIAL FUNCTIONS
#######################################################

# Goes up a specified number of directories  (i.e. up 4)
up() {
	local d=""
	limit=$1
	for ((i = 1; i <= limit; i++)); do
		d=$d/..
	done
	d=$(echo $d | sed 's/^\///')
	if [ -z "$d" ]; then
		d=..
	fi
	cd $d
}

# Automatically do an ls after each cd, z, or zoxide
cd ()
{
	if [ -n "$1" ]; then
		builtin cd "$@" && ls
	else
		builtin cd ~ && ls
	fi
}

# Show the current distribution
distribution () {
    local dtype="unknown"  # Default to unknown

    # Use /etc/os-release for modern distro identification
    if [ -r /etc/os-release ]; then
        source /etc/os-release
        case $ID in
            fedora|rhel|centos)
                dtype="redhat"
                ;;
            sles|opensuse*)
                dtype="suse"
                ;;
            ubuntu|debian)
                dtype="debian"
                ;;
            gentoo)
                dtype="gentoo"
                ;;
            arch|manjaro)
                dtype="arch"
                ;;
            slackware)
                dtype="slackware"
                ;;
            *)
                # Check ID_LIKE only if dtype is still unknown
                if [ -n "$ID_LIKE" ]; then
                    case $ID_LIKE in
                        *fedora*|*rhel*|*centos*)
                            dtype="redhat"
                            ;;
                        *sles*|*opensuse*)
                            dtype="suse"
                            ;;
                        *ubuntu*|*debian*)
                            dtype="debian"
                            ;;
                        *gentoo*)
                            dtype="gentoo"
                            ;;
                        *arch*)
                            dtype="arch"
                            ;;
                        *slackware*)
                            dtype="slackware"
                            ;;
                    esac
                fi

                # If ID or ID_LIKE is not recognized, keep dtype as unknown
                ;;
        esac
    fi

    echo $dtype
}


DISTRIBUTION=$(distribution)
if [ "$DISTRIBUTION" = "redhat" ] || [ "$DISTRIBUTION" = "arch" ]; then
      alias cat='bat'
else
      alias cat='batcat'
fi 

# Show the current version of the operating system
ver() {
    local dtype
    dtype=$(distribution)

    case $dtype in
        "redhat")
            if [ -s /etc/redhat-release ]; then
                cat /etc/redhat-release
            else
                cat /etc/issue
            fi
            uname -a
            ;;
        "suse")
            cat /etc/SuSE-release
            ;;
        "debian")
            cat /etc/os-release
            ;;
        "gentoo")
            cat /etc/gentoo-release
            ;;
        "arch")
            cat /etc/os-release
            ;;
        "slackware")
            cat /etc/slackware-version
            ;;
        *)
            if [ -s /etc/issue ]; then
                cat /etc/issue
            else
                echo "Error: Unknown distribution"
                exit 1
            fi
            ;;
    esac
}

# IP address lookup
alias whatismyip="whatsmyip"
function whatsmyip () {
    # Internal IP Lookup.
    if command -v ip &> /dev/null; then
        echo -n "Internal IP: "
        ip addr show wlan0 | grep "inet " | awk '{print $2}' | cut -d/ -f1
    else
        echo -n "Internal IP: "
        ifconfig wlan0 | grep "inet " | awk '{print $2}'
    fi

    # External IP Lookup
    echo -n "External IP: "
    curl -4 ifconfig.me
    echo
}

lazyg() {
	git add .
	git commit -m "$1"
	git push
}
