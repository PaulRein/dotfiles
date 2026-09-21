#! /bin/zsh
# set the trace prompt to include seconds, nanoseconds, script name and line number
#PS4='+$(gdate "+%s:%N") %N:%i> '
# save file stderr to file descriptor 3 and redirect stderr (including trace 
# output) to a file with the script's PID as an extension
#exec 3>&2 2>/tmp/startlog.$$
# set options to turn on tracing and expansion of commands contained in the prompt
#setopt xtrace prompt_subst

autoload -U compinit zrecompile

zsh_cache=${HOME}/.zsh/cache
mkdir -p $zsh_cache

if [ $UID -eq 0 ]; then
    compinit
else
    compinit -d $zsh_cache/zcomp-$HOST

    for f in ~/.zshrc $zsh_cache/zcomp-$HOST; do
        zrecompile -p $f && rm -f $f.zwc.old
    done
fi

if [[ -f /Users/paulrein/perl5/perlbrew/etc/bashrc ]] ; then
    source /Users/paulrein/perl5/perlbrew/etc/bashrc
    source /Users/paulrein/perl5/perlbrew/etc/perlbrew-completion.bash
fi

setopt extended_glob
for zshrc_snipplet in ~/.zsh/rc/S[0-9][0-9]*[^~] ; do
    source $zshrc_snipplet
done

HELPDIR=/usr/local/share/zsh/help

# . /usr/local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh

# turn off tracing
#unsetopt xtrace
# restore stderr to the value saved in FD 3
#exec 2>&3 3>&-

# OPAM configuration
. /Users/paulrein/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

# rupa/z
. /usr/local/etc/profile.d/z.sh
# if command -v pyenv 1>/dev/null 2>&1; then
#   eval "$(pyenv init -)"
# fi


[[ -s "$HOME/bin/" ]] && source "$HOME/bin/na.sh"
[[ -s "$HOME/bin/" ]] && source "$HOME/bin/td"

source /usr/local/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# For the CapsuleCorp virtual network used in The Art of Network Penetration Testing
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# create hatch completions
. ~/.hatch-complete.zsh

# Created by `pipx` on 2024-09-28 10:13:23
export PATH="$PATH:/Users/paulrein/.local/bin"

eval "$(_ABNF_TO_PLANTUML_COMPLETE=zsh_source abnf-to-plantuml)"

# Created by `userpath` on 2026-07-11 11:23:49
export PATH="$PATH:/Users/paulrein/Library/Application Support/hatch/pythons/3.14/python/bin"
eval "$(ruff generate-shell-completion zsh)"
