# Customize to your needs...

compdef '_command_names -e' notify
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

export EDITOR='emacsclient -n'
export VISUAL='emacsclient -n'

export LESSCHARSET=utf-8

autoload -U zargs
autoload -U zrecompile

autoload -U url-quote-magic
zle -N self-insert url-quote-magic

autoload zed

setopt nolistambiguous
autoload -U compinit && compinit

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

alias killEmacs="emacsclient --eval '(let (kill-emacs-hook) (kill-emacs))'"
export LEDGER_FILE="$HOME/hledger/hledger.journal"
