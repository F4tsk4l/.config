## Picom used
Jonaburg Picom "*[github](https://github.com/jonaburg/picom)*".

#### Installation 
    git clone https://github.com/jonaburg/picom
    cd picom
    meson --buildtype=release . build
    ninja -C build
#### To install the binaries in /usr/local/bin (optional)
    sudo ninja -C build install
