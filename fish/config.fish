#set fish_tmux_default_session_name 'launch'
#set fish_tmux_autoquit false
#set fish_tmux_detached true
#set fish_tmux_fixterm_with_256color true
#set fish_tmux_fixterm_without_256color true
#set fish_tmux_autostart true
#set fish_tmux_autostart_once true
#set fish_tmux_autoconnect false
#set fish_tmux_unicode true
#set fish_tmux_config /home/g4m3r/.config/tmux/tmux.conf

#if status is-interactive
#    if not set -q TMUX
#        if test -e "$HOME/.tmux_launched"
#            set -g TMUX tmux new -d -s launch
#            touch "$HOME/.tmux_launched"
#            eval $TMUX
#        else
#            set session_exists (tmux has-session -t launch; echo $status)
#            if test $session_exists -eq 0
#                tmux a -d -t launch
#            else
#                rm -f "$HOME/.tmux_launched"
#            end
#        end
#    end
#end

if status is-interactive
    if not set -q TMUX
        set session_exists (tmux has-session -t launch; echo $status)
        if test $session_exists -eq 1
            set -g TMUX tmux new -d -s launch
            eval $TMUX
            tmux a -d -t launch
        end
    end
end

set -g PATH "$HOME/.local/bin:$PATH"
set fish_greeting ""

function st_docker
sudo systemctl start docker.socket && sudo systemctl start docker
end
function sp_docker
sudo systemctl stop docker.socket && sudo systemctl stop docker
end
alias clo "xsel -i --clipboard"
alias cli "xsel -o --clipboard"
alias ls "eza --icons"
alias ll "eza -al --icons"
alias l  "eza -a --icons"
alias cat "bat"
alias rmr "rm -rf"
alias cls "clear"
alias yayi "yay -S --cleanafter"
#Set whoami variable
#set me "$(whoami)"
#alias notes "nvim /run/media/"$me"/Local\ Disk/Txt/Notes.txt"
#alias cdld "cd /run/media/"$me"/Local\ Disk/"
#alias vim "nvim"

export VISUAL=nvim
export EDITOR="$VISUAL"
export BAT_THEME="TwoDark"
export BAT_STYLE="full"

