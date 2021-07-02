# Customize to your needs...

autoload colors zsh/terminfo
#}}}


#关于历史纪录的配置 {{{
#历史纪录条目数量
export HISTSIZE=10000
#注销后保存的历史纪录条目数量
export SAVEHIST=10000
#历史纪录文件
#以附加的方式写入历史纪录
setopt INC_APPEND_HISTORY
#如果连续输入的命令相同，历史纪录中只保留一个
setopt HIST_IGNORE_DUPS
#为历史纪录中的命令添加时间戳
setopt EXTENDED_HISTORY
#除了支持经典的通配符之外，如果设置了 EXTENDEDGLOB ，那么 zsh 还支持一些扩展的通配符：
setopt EXTENDEDGLOB


#启用 cd 命令的历史纪录，cd -[TAB]进入历史路径
setopt AUTO_PUSHD
#相同的历史路径只保留一个
setopt PUSHD_IGNORE_DUPS

#在命令前添加空格，不将此命令添加到纪录文件中
#setopt HIST_IGNORE_SPACE
#}}}

#杂项 {{{
#允许在交互模式中使用注释  例如：
#cmd #这是注释
setopt INTERACTIVE_COMMENTS

#启用自动 cd，输入目录名回车进入目录
#稍微有点混乱，不如 cd 补全实用
#setopt AUTO_CD

#扩展路径
#/v/c/p/p => /var/cache/pacman/pkg
setopt complete_in_word

#禁用 core dumps
limit coredumpsize 0

#Emacs风格 键绑定
#设置 [DEL]键 为向后删除
bindkey "\e[3~" delete-char

#以下字符视为单词的一部分
WORDCHARS='*?_-[]~=&;!#$%^(){}<>'
#}}}

#自动补全功能 {{{
setopt AUTO_LIST
setopt AUTO_MENU

autoload -U compinit
compinit

#自动补全选项
zstyle ':completion:*' verbose yes
zstyle ':completion:*' menu select
zstyle ':completion:*:*:default' force-list always
zstyle ':completion:*' select-prompt '%SSelect:  lines: %L  matches: %M  [%p]'

zstyle ':completion:*:match:*' original only
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:*' completer _complete _prefix _correct _prefix _match _approximate

#路径补全
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'
zstyle ':completion::complete:*' '\\'

#彩色补全菜单
eval $(dircolors -b ~/.dir_colors)
export CLICOLOR=YES
export ZLSCOLORS="${LS_COLORS}"
zmodload zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

#修正大小写
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
#错误校正
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

#kill 命令补全
compdef pkill=killall
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:processes' command 'ps -au$USER'

#补全类型提示分组
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'
zstyle ':completion:*:corrections' format $'\e[01;32m -- %d (errors: %e) --\e[0m'

# cd ~ 补全顺序
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
#}}}

compdef '_command_names -e' notify

ptyrun () {
    local ptyname=pty-$$
    zmodload zsh/zpty
    zpty $ptyname ${1+"$@"}
    if [[ ! -t 1 ]]; then
        setopt local_traps
        trap '' INT
    fi
    zpty -r $ptyname
    zpty -d $ptyname
}
ptyless () {
    ptyrun $@ | less
}

#程序关联
alias -s js='emacsclient -n'
alias -s ts='emacsclient -n'
alias -s hs='emacsclient -n'
alias -s php='emacsclient -n'
alias -s ps=zathura
alias -s html= firefox
alias -s eps=zathura
alias -s pl=perl
alias -s py=python

export EDITOR=nvim
export VISUAL=nvim

## Colorful Less {{{
export LESS_TERMCAP_md=$'\E[1;31m'      #bold1
export LESS_TERMCAP_mb=$'\E[1;31m'
export LESS_TERMCAP_me=$'\E[m'
export LESS_TERMCAP_so=$'\E[01;44;33m'  #search highlight
export LESS_TERMCAP_se=$'\E[m'
export LESS_TERMCAP_us=$'\E[1;2;32m'    #bold2
export LESS_TERMCAP_ue=$'\E[m'
export LESS="-M -i -R --shift 5"
export LESSCHARSET=utf-8

autoload -U zargs
autoload -U zrecompile

autoload -U url-quote-magic
zle -N self-insert url-quote-magic

autoload zed

setopt nolistambiguous
autoload -U compinit && compinit

bindkey "\C-r" history-incremental-pattern-search-backward
bindkey "\C-n" history-incremental-pattern-search-forward
bindkey "\eq" push-line-or-edit
bindkey "\C-o" accept-line-and-down-history
# export MANPAGER="/bin/sh -c \"col -b | nvim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
#     source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
# fi
setopt clobber

backup_decrypt() {
    absolute_path=$([ "$1" != "${1#/}" ] && echo "$1" || echo "${PWD}/${1}")
    if [ ! -f $absolute_path ] ; then
        echo "File not found!"
        return
    fi
    decrypted_file=${absolute_path/%.gpg/""}
    gpg -o ${decrypted_file} -r "support@egenerationmarketing.com" -d $absolute_path
    echo "Decrypted output: ${decrypted_file}"
}

alias bd='backup_decrypt'

alias dot-git='git --git-dir=$HOME/.myconf/ --work-tree=$HOME'
