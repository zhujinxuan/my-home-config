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

prompt='%1/ %(!.#.$) '
bindkey '^[OP'   set-mark-command
bindkey '^W' kill-region
bindkey '^[^H'  describe-key-briefly
bindkey '^[^W' where-is

# recolor command-line {{{
TOKENS_FOLLOWED_BY_COMMANDS=('|' '||' ';' '&' '&&' 'sudo' 'do' 'time' 'strace' 'ptyless' 'tsocks')

#}}}

[ -x /usr/bin/src-hilite-lesspipe.sh ] && export LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s"
#}}}

confirm_yes() {
    sure=$(dialog --stdout  --inputbox "Are you sure that you want to run '$1' command? Type YES to confirm." 10 50)
    [[ $sure == YES ]] && $1
}


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

export PATH=/usr/local/texlive/2016/bin/x86_64-linux:$PATH
export MANPATH=/usr/local/texlive/2016/texmf-dist/doc/man:$MANPATH
export INFOPATH=/usr/local/texlive/2016/texmf-dist/doc/info:$INFOPATH

if [ ! -d /tmp/neovim ]; then 
    mkdir -p /tmp/neovim
fi


autoload -Uz promptinit
promptinit

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm


export PATH=.gem/ruby/2.0.0/bin:$PATH
alias python='python3'
export PATH="$HOME/.composer/vendor/bin:$PATH"
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

export PATH=$PATH:$HOME/.cabal/bin/:$HOME/.local/bin/


# added by travis gem
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh

export GPG_TTY=$(tty)
export HOMEBREW_GITHUB_API_TOKEN="3453d6bbb1de7a4f7a21ec56539e07f841a167dc"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
export PATH=$HOME/.cargo/bin:$PATH


export NIX_GHC_LIBDIR=$(ghc --print-libdir)

alias mamp-php='/Applications/MAMP/bin/php/php7.4.9/bin/php'
alias mamp-mysqldump=/Applications/MAMP/Library/bin/mysqldump
alias mamp-mysql=/Applications/MAMP/Library/bin/mysql
alias ghcide=$HOME/.local/bin/ghcide
eval "$(direnv hook zsh)"
