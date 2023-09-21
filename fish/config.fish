if status is-interactive
and not set -q TMUX
    exec tmux 
end
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

function cls
clear
end

#function dl
#cd /run/media/Cr33p3r/Local Disk/
#end

alias ld "cd '/run/media/cr33p3r/Local\ Disk/'"
function yayi
yay -S --cleanafter
end

set -g PATH "$HOME/emmcdl:$PATH"
set -g PATH "$HOME/.local/bin:$PATH"
set -g PATH "$HOME/Downloads/Compressed/jcryptool:$PATH"
#set -g dlp "/run/media/Cr33p3r/Local Disk/"
set fish_greeting ""
export VISUAL=vim
export EDITOR="$VISUAL"

#if [-z "$TMUX"]; then tmux; fi
