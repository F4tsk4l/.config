#if status is-interactive
#and not set -q TMUX
#    exec tmux 
#end
function st_docker
sudo systemctl start docker.socket && sudo systemctl start docker
end
function sp_docker
sudo systemctl stop docker.socket && sudo systemctl stop docker
end
alias ls "eza --icons"
alias ll "eza -al --icons"
alias l  "eza -a --icons"
alias vim "nvim"
alias rmr "rm -rf"
alias cls "clear"
alias cdld "cd '/run/media/sc0rp/Local Disk/'"
alias yayi "yay -S --cleanafter"

set -g PATH "$HOME/.local/bin:$PATH"
set fish_greeting ""
export VISUAL=nvim
export EDITOR="$VISUAL"

#if [-z "$TMUX"]; then tmux; fi
