# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

## Options section
setopt correct                                                  # Auto correct mistakes
setopt extendedglob                                             # Extended globbing. Allows using regular expressions with *
setopt nocaseglob                                               # Case insensitive globbing
setopt rcexpandparam                                            # Array expension with parameters
setopt nocheckjobs                                              # Don't warn about running processes when exiting
setopt numericglobsort                                          # Sort filenames numerically when it makes sense
setopt nobeep                                                   # No beep
setopt appendhistory                                            # Immediately append history instead of overwriting
setopt histignorealldups                                        # If a new command is a duplicate, remove the older one
setopt autocd                                                   # if only directory path is entered, cd there.

export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim

HISTFILE=~/.zhistory
HISTSIZE=1000
SAVEHIST=500
WORDCHARS=${WORDCHARS//\/[&.;]}                                 # Don't consider certain characters part of the word


# Keybindings section
bindkey -e
bindkey '^[[7~' beginning-of-line                               # Home key
bindkey '^[[H' beginning-of-line                                # Home key
if [[ "${terminfo[khome]}" != "" ]]; then
    bindkey "${terminfo[khome]}" beginning-of-line                # [Home] - Go to beginning of line
fi
bindkey '^[[8~' end-of-line                                     # End key
bindkey '^[[F' end-of-line                                     # End key
if [[ "${terminfo[kend]}" != "" ]]; then
    bindkey "${terminfo[kend]}" end-of-line                       # [End] - Go to end of line
fi
bindkey '^[[2~' overwrite-mode                                  # Insert key
bindkey '^[[3~' delete-char                                     # Delete key
bindkey '^[[C'  forward-char                                    # Right key
bindkey '^[[D'  backward-char                                   # Left key
bindkey '^[[5~' history-beginning-search-backward               # Page up key
bindkey '^[[6~' history-beginning-search-forward                # Page down key

# Navigate words with ctrl+arrow keys
bindkey '^[Oc' forward-word                                     #
bindkey '^[Od' backward-word                                    #
bindkey '^[[1;5D' backward-word                                 #
bindkey '^[[1;5C' forward-word                                  #

#bindkey '^H' backward-kill-word                                 # delete previous word with ctrl+backspace
bindkey '^[[Z' undo                                             # Shift+tab undo last action

#nvim() {
#    if [[ -z $NVIM_LISTEN_ADDRESS ]]; then
#        nvim.appimage "$@"
#    else
#        nvim.appimage --server $NVIM_LISTEN_ADDRESS --remote-tab "$@"
#    fi
#}

# Alias section 
alias ls="ls --color=auto"
alias ll="ls -l"
alias l="ll"
alias cp="cp -i"                                                # Confirm before overwriting something
alias fzf="fzf --ansi"
alias df='df -h'                                                # Human-readable sizes
alias free='free -m'                                            # Show sizes in MB
alias gitu='git add . && git commit && git push'
alias tmux=tmux.appimage
alias vim=nvim
alias vi=vim
alias ssh='ssh -o StrictHostKeyChecking=no'
alias sftp='sftp -o StrictHostKeyChecking=no'
alias sshp='sshpass -e ssh -o StrictHostKeyChecking=no'
alias sftpp='sshpass -e sftp -o StrictHostKeyChecking=no'

# Theming section  
autoload -U compinit colors zcalc
compinit -d
colors

# enable substitution for prompt
setopt prompt_subst

# Color man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-r

export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --exclude .git --color=always'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--layout=reverse --ansi"

## Plugins section: Enable fish style features
# Use syntax highlighting
source ~/.local/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# Use syntax highlighting
source ~/.local/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Use history substring search
source ~/.local/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
# Use powerlevel10k theme
source ~/.local/share/zsh/plugins/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
# Use fzf-tab plugin
source ~/.local/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh

# bind UP and DOWN arrow keys to history substring search
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '<Up>' history-substring-search-up
bindkey '<Down>' history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"         # Colored completion (different colors for dirs/files/etc)
zstyle ':completion:*' rehash true                              # automatically find new executables in path 
# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
# disable sort when completingon't warn about zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
# switch group using

# andnable
zstyle ':fzf-tab:*' switch-group ',' '.'

export ANDROID_SDK_ROOT=/opt/android-sdk

export PATH=$HOME/.local/go/bin:$HOME/.local/bin:$HOME/.gem/ruby/3.0.0/bin:$PATH
export PATH=$PATH:$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/platform-tools
export GITHUB_TOKEN=***REDACTED_GITHUB_TOKEN***

export FLUTTER_STORAGE_BASE_URL="https://mirrors.tuna.tsinghua.edu.cn/flutter"
export PUB_HOSTED_URL="https://mirrors.tuna.tsinghua.edu.cn/dart-pub"

export RUSTUP_UPDATE_ROOT=https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup
export RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup
source /usr/share/nvm/init-nvm.sh
