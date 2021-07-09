# Source Prezto.
PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

#显示 path-directories ，避免候选项唯一时直接选中
cdpath="/home"
#}}}

zstyle ':completion:*:my-accounts' users-hosts $my_accounts


mkcd () {
    mkdir -p "$*"
    cd "$*"
}

# }}}

# recolor command-line {{{
TOKENS_FOLLOWED_BY_COMMANDS=('|' '||' ';' '&' '&&' 'sudo' 'do' 'time' 'strace' 'ptyless' 'tsocks')

#}}}

user-ret(){
    if [[ $BUFFER = "" ]] ;then
        BUFFER="ls"
        zle end-of-line
        zle accept-line
    elif [[ $BUFFER =~ "^cd\ \.\.\.+$" ]] ;then
        BUFFER=${${BUFFER//\./\.\.\/}/\.\.\//}
        zle end-of-line
        zle accept-line
    else
        zle accept-line
    fi
}
zle -N user-ret

if [ ! -d /tmp/neovim ]; then
    mkdir -p /tmp/neovim
fi


autoload -Uz promptinit
promptinit

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm


export PATH=.gem/ruby/2.0.0/bin:$PATH
export PATH="$HOME/.composer/vendor/bin:$PATH"
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

export PATH=$PATH:$HOME/.cabal/bin/:$HOME/.local/bin/

export GPG_TTY=$(tty)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
export PATH=$HOME/.cargo/bin:$PATH

export NIX_GHC_LIBDIR=$(ghc --print-libdir)

alias mamp-mysqldump=/Applications/MAMP/Library/bin/mysqldump
alias mamp-mysql=/Applications/MAMP/Library/bin/mysql
# eval "$(direnv hook zsh)"
# export KALEIDOSCOPE_DIR=${HOME}/git/Kaleidoscope

source ./sensitive.zsh
