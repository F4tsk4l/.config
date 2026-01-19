#FISH TMUX PLUGIN conf
#set fish_tmux_default_session_name 'launch'
#set fish_tmux_autoquit false
#set fish_tmux_detached true
#set fish_tmux_fixterm_with_256color true
#set fish_tmux_fixterm_without_256color true
#set fish_tmux_autostart true
#set fish_tmux_autostart_once true
#set fish_tmux_autoconnect false
#set fish_tmux_unicode true
set -x EDITOR nvim

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

set -g PATH "$HOME/.cargo/bin:$PATH"
set -g PATH "$HOME/.local/bin:$PATH"
set -g PATH "$HOME/.config/awesome/scripts:$PATH"
#set -g ANDROID_SDK_PATH "/opt/android-sdk/"
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
alias l "eza -a --icons"
#alias cat bat
alias rmr "rm -rf"
alias cls clear
alias yayi "yay -a -S --cleanafter"
alias rename perl-rename
alias ncmp ncmpcpp
alias yay "yay -a"
#alias wine "wine64"
#alias vim "nvim"
#bind --mode insert ii 'commandline -r ""'
#bind --mode visual ii 'commandline -r ""'
#bind --mode command ii 'commandline -r ""'

#Vi Mode keybindings
#set -g fish_key_bindings fish_vi_key_bindings
#set -g fish_vi_key_bindings fish_vi_key_bindings
fish_vi_key_bindings default
#set -g fish_vi_key_bindings = fish_vi_key_bindings default
bind --mode insert --sets-mode default jk repaint
bind --mode replace --sets-mode default jk repaint
set -g fish_sequence_key_delay_ms 500
#function back_to_normal --on-event fish_prompt
#    fish_vi_key_bindings default
#end

#Set whoami variable
#set me "$(whoami)"
alias notes "nvim /home/g4m3r/Desktop/Mu5tur4d/N0t35/notes.md"
alias parts "nvim /home/g4m3r/Desktop/Mu5tur4d/N0t35/parts.md"
alias ltxn "nvim /home/g4m3r/Desktop/Mu5tur4d/N0t35/LaTex.md"
#alias cdld "cd /run/media/"$me"/Local\ Disk/"

export VISUAL=nvim
export EDITOR="$VISUAL"
export BAT_THEME="TwoDark"
export BAT_STYLE="full"

# Solarized Dark & Green highlight
set -g man_blink -o red
set -g man_bold -o blue
set -g man_standout -b black red
set -g man_underline -u 93a1a1

fzf --fish | source
export FZF_DEFAULT_OPTS='--layout reverse --border bold --margin 3% --border rounded --color dark'
