Config {

   -- Appearance
     -- font = "xft:Terminus-11"
     font            = "Joist Bold Italic 8"
       , additionalFonts = [ "symbols nerd font 11"
                            , "Mononoki Nerd Font 30"
       
                           ]

     , borderColor = "black"
     , border = TopB
     , bgColor = "black"
     , iconRoot     = ".xmonad/xpm/"  -- default: "."
     , fgColor = "#F8F8F8"
     , alpha = 140
     -- position = TopP 0 40
     -- position = TopW L 95
     , position = Static {xpos = 0, ypos = 0, width = 1298, height = 17}
     , allDesktops = True
     , overrideRedirect = True

   -- Layout
     , sepChar =  "%"   -- delineator between plugin names and straight text
     , alignSep = "}{"  -- separator between left-right alignment
     , template = "%UnsafeStdinReader% }{ %date% |  %disku%  |  %multicpu%  |  %coretemp%  |  %swap%  |  %memory%  |  %dynnetwork%  | %battery%"  

   -- general behavior
     , lowerOnStart = True    -- send to bottom of window stack on start
     , hideOnStart =  False   -- start with window unmapped (hidden)
   -- overrideRedirect = True    -- set the Override Redirect flag (Xlib)
     , pickBroadest = False   -- choose widest display (multi-monitor)
     , persistent = True    -- enable/disable hiding (True = disabled)
     -- allDesktops = True
   -- plugins
   --   Numbers can be automatically colored according to their value. xmobar
   --   decides color based on a three-tier/two-cutoff system, controlled by
   --   command options:
   --     --Low sets the low cutoff
   --     --High sets the high cutoff
   --
   --     --low sets the color below --Low cutoff
   --     --normal sets the color between --Low and --High cutoffs
   --     --High sets the color above --High cutoff
   --
   --   The --template option controls how the plugin is displayed. Text
   --   color can be set by enclosing in <fc></fc> tags. For more details
   --   see http://projects.haskell.org/xmobar/#system-monitor-plugins.

     , commands =

        -- weather monitor
        [

        -- Network activity monitor (dynamic interface resolution)
          Run DynNetwork     [ "--template" , "<dev> <fn=1>\xf1eb</fn>  :  <tx> kB/s | <rx> kB/s"
                             , "--Low"      , "1000"       -- units: B/s
                             , "--High"     , "5000"       -- units: B/s
                             , "--low"      , "#ABABAB"
                             , "--normal"   , "white"
                             , "--high"     , "#2ECC71"
                             ] 10

        -- Cpu activity monitor
        , Run MultiCpu       [ "--template" , "<fn=1>\xf0ee0</fn>  :  <total0> %"
                             , "--Low"      , "50"         -- units: %
                             , "--High"     , "85"         -- units: %
                             , "--low"      , "#ABABAB"
                             , "--normal"   , "white"
                             , "--high"     , "red"
                             ] 10

        -- Cpu core temperature monitor
        , Run CoreTemp       [ "--template" , "<fn=1>\xf2c8</fn>  :  <core0>°C"
                             , "--Low"      , "70"        -- units: °C
                             , "--High"     , "80"        -- units: °C
                             , "--low"      , "#ABABAB"
                             , "--normal"   , "white"
                             , "--high"     , "red"
                             ] 50

        -- Memory usage monitor
        , Run Memory         [ "--template" , "<fn=1>\xf035b</fn>  :  <used>MiB"
                             , "--Low"      , "1536"        -- units: %
                             , "--High"     , "2560"        -- units: %
                             , "--low"      , "#ABABAB"
                             , "--normal"   , "white"
                             , "--high"     , "red"
                             ] 10

        -- Battery monitor
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

        -- Time and date indicator
        , Run Date           "<fc=#2ECC71>%F</fc>   <fc=blue>(%a)</fc>   <fc=#2ECC71>%T</fc>" "date" 10

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

        -- Run Wireless "wlo1" ["-t", "<essid>"] 10

        --Run StdinReader
        , Run UnsafeStdinReader
           -- Script that dynamically adjusts xmobar padding depending on number of trayer icons.
--        , Run Com "/home/cr33p3r/.config/xmobar/trayer-padding-icon.sh" [] "trayerpad" 5 

       ]
}
