if status is-interactive
    if not set -q TMUX
        set -g TMUX tmux new -d -s base
        eval $TMUX
        tmux a -d -t base
    end
end
function st_docker
sudo systemctl start docker.socket && sudo systemctl start docker
end
function sp_docker
sudo systemctl stop docker.socket && sudo systemctl stop docker
end
alias cl "xsel -i --clipboard"
alias ls "eza --icons"
alias ll "eza -al --icons"
alias l  "eza -a --icons"
#Set whoami variable
set me "$(whoami)"
alias notes "nvim /run/media/"$me"/Local\ Disk/Txt/Notes.txt"
#alias vim "nvim"
alias rmr "rm -rf"
alias cls "clear"
alias cdld "cd /run/media/"$me"/Local\ Disk/"
alias yayi "yay -S --cleanafter"

set -g PATH "$HOME/.local/bin:$PATH"
set fish_greeting ""
export VISUAL=nvim
export EDITOR="$VISUAL"

