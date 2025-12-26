Config {
   -- Appearance
       font            = "Joist Bold Italic 8"
     , additionalFonts = [ "symbols nerd font 10"
                          , "Mononoki Nerd Font 20"
                         ]
     , borderColor = "black"
     , border = TopB
     , bgColor = "black"
     , iconRoot = "/home/g4m3r/.xmonad/xpm/"  -- default: "."
     , fgColor = "#F8F8F8"
     , alpha = 190
     -- position = TopP 0 40
     -- position = TopW L 95
     , position =  TopSize L 100 18 
     --, position = Static {xpos = 0, ypos = 0, width = 1298, height = 17}
     , allDesktops = True
     , overrideRedirect = True
     , lowerOnStart = True    -- send to bottom of window stack on start
     , hideOnStart =  False   -- start with window unmapped (hidden)
   -- overrideRedirect = True -- set the Override Redirect flag (Xlib)
     , pickBroadest = False   -- choose widest display (multi-monitor)
     , persistent = True -- enable/disable hiding (True = disabled)

     , commands =
        [
          Run DynNetwork     [ "--template" , ": <tx> : <rx>"
                             , "--suffix"   , "True"
                             , "--Low"      , "1000"       -- units: B/s
                             , "--High"     , "100000"       -- units: B/s
                             , "--low"      , "#F8F8F8"
                             , "--normal"   , "#F8F8F8"
                             , "--high"     , "#2ECC71"
                             ] 10
        , Run MultiCpu       [ "--template" , "<fc=#E88D67><fn=1>\xf0ee0</fn></fc> : <total0> %"
                             , "--Low"      , "50"         -- units: %
                             , "--High"     , "85"         -- units: %
                             , "--low"      , "#F8F8F8"
                             , "--normal"   , "#F8F8F8"
                             , "--high"     , "#FF000D"
                             ] 10
        , Run CoreTemp       [ "--template" , "<fc=#FF000D><fn=1>\xf2c8</fn></fc> : <core0> °C"
                             , "--Low"      , "70"        -- units: °C
                             , "--High"     , "80"        -- units: °C
                             , "--low"      , "#F8F8F8"
                             , "--normal"   , "#F8F8F8"
                             , "--high"     , "#FF000D"
                             ] 50
        , Run Memory         [ "--template" , "<fc=#D10363><fn=1>\xf035b</fn></fc> : <used> MB"
                             , "--Low"      , "1536"        -- units: %
                             , "--High"     , "2560"        -- units: %
                             , "--low"      , "#F8F8F8"
                             , "--normal"   , "#F8F8F8"
                             , "--high"     , "#FF000D"
                             ] 10
        , Run Battery        [ "--template" , "<acstatus>"
                             , "--Low"      , "30"        -- units: %
                             , "--High"     , "85"        -- units: %
                             , "--low"      , "#FF000D"
                             , "--normal"   , "#F8F8F8"
                             , "--high"     , "#F8F8F8"
                             , "--" -- battery specific options
                                       -- discharging status
                                       , "-o"	, "<fc=#59D5E0><fn=1>\xf0080</fn></fc>  <left>% (<timeleft>)"
                                       -- AC "on" status
                                       , "-O"	, "<fc=#59D5E0><fn=1>\xf0089</fn></fc>  <left>%"
                                       -- charged status
                                       , "-i"	, "<fc=#59D5E0><fn=1>\xf0079</fn></fc>  <left>%"
                             ] 50
        , Run Date           "<fc=#F8F8F8><fn=1>\xf00ed</fn>  %F</fc> <fc=#BC5A94>  %A </fc> <fc=#F8F8F8><fn=1>\xe641</fn>  %H:%M </fc>" "date" 10
        -- Run Kbd            [ ("us"  , "<fc=#FF000D>US")]
        , Run Swap           [ "--template" ,"<fc=#03AED2><fn=1>\xf0fb4</fn></fc> : <used> MB"
                             , "--Low"      , "500"        -- units: %
                             , "--High"     , "1504"        -- units: %
                             , "--low"      , "#F8F8F8"
                             , "--normal"   , "#F8F8F8"
                             , "--high"     , "#FF000D"
                             ] 10
        , Run DiskU         [("/", "<fc=#FFF455><fn=1>\xf02ca</fn></fc> : <free>")] [] 60
        , Run MPD           [ "-t", "<state>: <artist> - <title> "
                              ,"-M", "35"]5
        , Run Com           "/home/g4m3r/.local/bin/connection" [] "mycon"  5
           -- Script that dynamically adjusts xmobar padding depending on number of trayer icons.
        , Run Com           "/home/g4m3r/.config/xmobar/trayer-padding.sh" [] "trayerpad" 5 
        , Run UnsafeStdinReader
       ]
    , sepChar =  "%"   -- delineator between plugin names and straight text
    , alignSep = "}{"  -- separator between left-right alignment
    , template = "%UnsafeStdinReader% }{<box type=Bottom width=2 mb=1 color=#E7D4B5>%mpd%</box>   <box type=Bottom width=2 mb=1 color=#E7D4B5>%date%</box>  <box type=Bottom width=2 mb=1 color=#E7D4B5> %disku% </box>  <box type=Bottom width=2 mb=1 color=#E7D4B5> %multicpu% </box>  <box type=Bottom width=2 mb=1 color=#E7D4B5> %coretemp% </box>  <box type=Bottom width=2 mb=1 color=#E7D4B5> %swap% </box>  <box type=Bottom width=2 mb=1 color=#E7D4B5> %memory% </box>  <box type=Bottom width=2 mb=1 color=#E7D4B5> <fc=#FF8080>%mycon%</fc>%dynnetwork% </box>  <box type=Bottom width=2 mb=1 color=#E7D4B5>  %battery% </box> %trayerpad%"
}
