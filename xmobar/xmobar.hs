Config {
   -- Appearance
     font            = "Joist Bold Italic 8"
       , additionalFonts = [ "symbols nerd font 10"
                            , "Mononoki Nerd Font 20"
       
                           ]
     --, borderColor = "black"
     --, border = TopB
     , bgColor = "black"
     , iconRoot     = "/home/sc0rp/.xmonad/xpm/"  -- default: "."
     , fgColor = "#F8F8F8"
     , alpha = 140
     -- position = TopP 0 40
     -- position = TopW L 95
     , position =  TopSize L 100 18 
     --, position = Static {xpos = 0, ypos = 0, width = 1298, height = 17}
     , allDesktops = True
     , overrideRedirect = True
     , sepChar =  "%"   -- delineator between plugin names and straight text
     , alignSep = "}{"  -- separator between left-right alignment
     , template = "%UnsafeStdinReader% }{ %date% |  %disku%  |  %multicpu%  |  %coretemp%  |  %swap%  |  %memory%  |  %mycon%%dynnetwork%  | %battery% |%trayerpad%"  

     , lowerOnStart = True-- send to bottom of window stack on start
     , hideOnStart =  False   -- start with window unmapped (hidden)
   -- overrideRedirect = True    -- set the Override Redirect flag (Xlib)
     , pickBroadest = False   -- choose widest display (multi-monitor)
     , persistent = True -- enable/disable hiding (True = disabled)

     , commands =
        [
          Run DynNetwork     [ "--template" , ":  <tx> kB/s | <rx> kB/s"
                             , "--Low"      , "1000"       -- units: B/s
                             , "--High"     , "5000"       -- units: B/s
                             , "--low"      , "#ABABAB"
                             , "--normal"   , "white"
                             , "--high"     , "#2ECC71"
                             ] 10
        , Run MultiCpu       [ "--template" , "<fn=1>\xf0ee0</fn>  :  <total0> %"
                             , "--Low"      , "50"         -- units: %
                             , "--High"     , "85"         -- units: %
                             , "--low"      , "#ABABAB"
                             , "--normal"   , "white"
                             , "--high"     , "red"
                             ] 10
        , Run CoreTemp       [ "--template" , "<fn=1>\xf2c8</fn>  :  <core0>°C"
                             , "--Low"      , "70"        -- units: °C
                             , "--High"     , "80"        -- units: °C
                             , "--low"      , "#ABABAB"
                             , "--normal"   , "white"
                             , "--high"     , "red"
                             ] 50
        , Run Memory         [ "--template" , "<fn=1>\xf035b</fn>  :  <used>MiB"
                             , "--Low"      , "1536"        -- units: %
                             , "--High"     , "2560"        -- units: %
                             , "--low"      , "#ABABAB"
                             , "--normal"   , "white"
                             , "--high"     , "red"
                             ] 10
        , Run Battery        [ "--template" , "<acstatus>"
                             , "--Low"      , "30"        -- units: %
                             , "--High"     , "85"        -- units: %
                             , "--low"      , "red"
                             , "--normal"   , "#ABABAB"
                             , "--high"     , "#ABABAB"


                             , "--" -- battery specific options
                                       -- discharging status
                                       , "-o"	, "<fc=#ABABAB><fn=1>\xf0079</fn></fc> <fc=#F8F8F8><left>% (<timeleft>)</fc>"
                                       -- AC "on" status
                                       , "-O"	, "<fc=#ABABAB><fn=1>\xf089e</fn></fc>  <fc=#F8F8F8><left>%</fc>"
                                       -- charged status
                                       , "-i"	, "<fc=#ABABAB><fn=1>\xf0085</fn></fc>  <fc=#F8F8F8><left>%</fc>"
                             ] 50
        , Run Date           "<fn=1>\xf00ed</fn><fc=#2ECC71>  %F</fc> <fc=white>| %a</fc>   <fn=1>\xe641</fn><fc=#2ECC71>  %T</fc>" "date" 10
        -- Keyboard layout indicator
        -- Run Kbd            [ ("us"  , "<fc=#8B0000>US</fc>")]
        , Run Swap           [ "--template" ,"<fn=1>\xf0fb4</fn>  :  <used> MiB"
                             , "--Low"      , "500"        -- units: %
                             , "--High"     , "1504"        -- units: %
                             , "--low"      , "#F8F8F8"
                             , "--normal"   , "white"
                             , "--high"     , "red"
                             ] 10
        , Run DiskU [("/", "<fn=1>\xf02ca</fn> : <fc=#F8F8F8><free></fc>")] [] 60
        , Run UnsafeStdinReader
           -- Script that dynamically adjusts xmobar padding depending on number of trayer icons.
        , Run Com "/home/sc0rp/.config/xmobar/trayer-padding.sh" [] "trayerpad" 5 
        , Run Com "/home/sc0rp/.local/bin/connection" [] "mycon"  5
       ]
}
