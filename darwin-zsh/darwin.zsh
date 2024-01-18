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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm


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
