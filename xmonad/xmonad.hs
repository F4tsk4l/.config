--IMPORT
import XMonad
import XMonad.Config.Desktop
import System.Directory
import System.IO
import System.Exit
import qualified XMonad.StackSet as W

-- Util
import Graphics.X11.ExtraTypes.XF86
import XMonad.Util.Hacks (windowedFullscreenFixEventHook, javaHack, trayerAboveXmobarEventHook, trayAbovePanelEventHook, trayerPaddingXmobarEventHook, trayPaddingXmobarEventHook, trayPaddingEventHook)
import XMonad.Util.Dmenu
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Cursor

-- Action
import XMonad.Actions.MouseResize
import XMonad.Actions.WorkspaceNames
import XMonad.Actions.SpawnOn
import XMonad.Actions.CycleWS (moveTo, shiftTo, WSType(..), nextScreen, prevScreen)

-- Layouts
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

-- Layouts modifiers
import XMonad.Layout.Gaps
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Actions.NoBorders
import XMonad.Layout.Fullscreen
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Renamed
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.Renamed
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowNavigation
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts)
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))
import XMonad.Layout.NoFrillsDecoration

-- Data
import Data.List
import Data.Monoid
import Data.Char (isSpace, toUpper)
import Data.Maybe (fromJust)
import Data.Maybe (isJust)
import Data.Tree
import qualified Data.Map as M

-- Hooks
import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops 
import XMonad.Hooks.Place
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog 
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.WindowSwallowing
import XMonad.Hooks.WorkspaceHistory
import XMonad.Hooks.ManageHelpers(doFullFloat, doCenterFloat, isFullscreen, isDialog)
import XMonad.Hooks.ManageDocks (avoidStruts, docks, manageDocks, ToggleStruts(..))
----------------------------------------------------------
-- MyTerminal
myTerminal :: String
myTerminal = "xfce4-terminal"

myFont :: String
myFont = "xft:Font Mono:regular:size=9:antialias=true:hinting=true"

-- Windows border in pixels
myBorderWidth :: Dimension
myBorderWidth = 1

myNormColor :: String
--myNormColor  = "#fd1c03"
myNormColor  = "#282c34"

myFocusedColor :: String
myFocusedColor = "#46d9ff"


-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- ModKey
myModMask :: KeyMask
myModMask = mod4Mask

-- MyWorkspaces
myWorkspaces :: [String]
myWorkspaces = map show [1..9]

-- Clickable workspaces
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..9] 
clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices

-----------------------------------------------------------
-- KeyBindings
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    -- launch dmenu
    , ((modm, xK_d), spawn "dmenu_run")
    -- launch gmrun
    , ((modm .|. shiftMask, xK_p), spawn "gmrun")
    -- close focused window
    , ((modm .|. shiftMask, xK_q), kill)
    , ((controlMask, xK_w), kill)
    -- Rotate through the available layout algorithms
    , ((modm, xK_space ), sendMessage NextLayout)
    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    -- Resize viewed windows to the correct size
    , ((modm, xK_r), refresh)
    -- Move focus to the next window
    , ((modm, xK_Tab   ), windows W.focusDown)
    -- Move focus to the next window
    , ((modm, xK_j), windows W.focusDown)
    -- Move focus to the previous window
    , ((modm, xK_k), windows W.focusUp  )
    -- Move focus to the master window
    , ((modm, xK_m), windows W.focusMaster)
    -- Swap the focused window and the master window
    , ((modm, xK_Return), windows W.swapMaster)
    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j), windows W.swapDown)
    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k), windows W.swapUp)
    -- Shrink the master area
    , ((modm, xK_h), sendMessage Shrink)
    -- Expand the master area
    , ((modm, xK_l), sendMessage Expand)
    -- Push window back into tiling
    , ((modm, xK_t), withFocused $ windows . W.sink)
    -- Increment the number of windows in the master area
    , ((modm, xK_comma), sendMessage (IncMasterN 1))
    -- Deincrement the number of windows in the master area
    , ((modm, xK_period), sendMessage (IncMasterN (-1)))
   ----------------------------------
    -- Quit xmonad
    , ((modm .|. shiftMask, xK_c), io (exitWith ExitSuccess))
    -- Restart xmonad
    , ((modm, xK_q), spawn "xmonad --recompile; xmonad --restart")
    -- MY KEYBINDINGS
    -- StartViper 
    , ((modm .|. shiftMask, xK_v), spawn "viper start; viper-gui -t")
    -- StopViper 
    , ((modm .|. mod1Mask, xK_v), spawn "viper stop; killall viper-gui")
    -- ((modm .|. shiftMask, xK_t), myTerminal -e kill "viper-gui")
    , ((modm, xK_n), spawnHere "nemo")
    , ((modm .|. controlMask, xK_b), sendMessage ToggleStruts)
    -- Fullscreen Toggle
    , ((modm, xK_f), sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts)
    -- Browsers
    , ((modm .|. shiftMask, xK_f), spawnHere "firefox")
    , ((modm .|. shiftMask, xK_b), spawnHere "brave")
    , ((modm .|. controlMask, xK_l), spawnHere "librewolf")
    -- Screenshot
    -- Flameshot 
    -- ((0 .|. mod1Mask, xK_Print), spawn "flameshot full -p $HOME/Pictures/Flameshts/Full/")
    -- ((0 .|. shiftMask, xK_Print), spawn "flameshot gui -p $HOME/Pictures/Flameshts/Selection/")
    , ((0 .|. mod1Mask, xK_Print), spawn "flameshot gui")
    -- Maim 
    , ((0, xK_Print), spawn "maim $HOME/Pictures/Maimshts/Full/$(date +%s).png")
    , ((0 .|. shiftMask, xK_Print), spawn "maim --select $HOME/Pictures/Maimshts/Selection/$(date +%s).png")
    , ((0 .|. controlMask, xK_Print), spawn "maim -i $(xdotool getactivewindow) -B $HOME/Pictures/Maimshts/ActiveW/$(date +%s).png")
    -- Morc menu
    , ((modm, xK_z), spawn "morc_menu")
    -- ScratchPads
    , ((modm .|. shiftMask, xK_s), withFocused $ toggleDynamicNSP "dny1")
    , ((modm, xK_s), dynamicNSPAction "dny1")
    -- Pavucontrol
    , ((modm .|. controlMask, xK_m), spawn "pavucontrol")
    -- Clipit
    , ((modm .|. shiftMask .|. controlMask, xK_c), spawn "clipit")
   ]++

    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m
        ) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

-- Fullscreen Toggle
--toggleFull = withFocused (\windowId -> do    
--{       
--   floats <- gets (W.floating.windowset);        
--   if windowId `M.member` floats        
--   then do  
--       withFocused $ toggleBorder 
--       withFocused $ windows.W.sink        
--   else do 
--       withFocused $ toggleBorder           
--       withFocused $  windows . (flip W.float $ W.RationalRect 0 0 1 1)})

-- My spacing; n sets the gap size around the windows.
------------------------------------------------------
tall     = renamed [Replace "tall"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ mySpacing 2
           $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "monocle"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ mySpacing 2
           $ Full
tabs     = renamed [Replace "tabs"]
           $ tabbed shrinkText myTabTheme
-----------------------------------------------------
myTabTheme = def { fontName            = myFont
                 , activeColor         = myFocusedColor 
                 , inactiveColor       = "#202328" 
                 , activeBorderColor   = myFocusedColor 
                 , inactiveBorderColor = myNormColor 
                 , activeTextColor     = myNormColor 
                 , inactiveTextColor   = "#dfdfdf" 
                 }

--myShowWNameTheme :: SWNConfig
--myShowWNameTheme = def
--  { swn_font              = "xft:Ubuntu:bold:size=60"
--  , swn_fade              = 0.5
--  , swn_bgcolor           = "#1c1f24"
--  , swn_color             = "#ffffff"
--  }
 
-- Layouts:
myLayoutHook = avoidStruts $ mouseResize $ windowArrange $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
             where
               myDefaultLayout = withBorder myBorderWidth tall
                                 ||| withBorder myBorderWidth monocle 
                                 ||| noBorders tabs

--Makes setting the spacingRaw simpler to write. The spacingRaw module adds a configurable amount of space around windows.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- WS Window Count
windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

-- MyStartup Hooks
myStartupHook :: X ()
myStartupHook = do
   spawnOnce "nitrogen --restore &"
   spawnOnce "picom &"
   spawnOnce "xfce4-notifyd &"
   spawnOnce "trayer --edge top --distance 0 --align right --widthtype request --iconspacing 3 --SetDockType true --padding 3 --expand True --monitor 1 --transparent true --alpha 100 --tint 0xff000000 --height 17 &"
   spawnOnce "xfce4-power-manager &"
   spawnOnce "pa-applet &"
   spawnOnce "start_conky_maia &"
   spawnOnce "xfce4-power-manager --daemon &"
 --  spawnOnce "exec xhost +SI:localuser:$USER &"

-- WINDOW RULES
myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
   [ className =? "Gimp"                        --> (doFullFloat <+> doShift "5")
   , className =? "PacketTracer"                --> doCenterFloat
   , resource  =? "desktop_window"              --> doIgnore
   , className =? "trayer"                      --> doIgnore
   , title     =? "* Properties"                  --> doCenterFloat
   -- className =? "libreoffice-base" <&&> resource =? "libreoffice" --> doShift "5"
   , resource  =? "libreoffice-writer"          --> (doFullFloat <+> doShift "5")
   , className =? "conky"                       --> doIgnore
   , className =? "Xfce4-notifyd"                       --> doIgnore
   , title     =? "Library"                     --> doCenterFloat
   , title     =? "Navigator"                     --> doCenterFloat
   , className =? "Navigator"                     --> doCenterFloat
   , className =? "Nitrogen"                    --> doCenterFloat
   , className =? "Browser"                     --> doCenterFloat
   , className =? "qbittorrent"                 --> doCenterFloat
   , className =? "Pavucontrol"                 --> doCenterFloat
   , className =? "jamesdsp"                    --> doCenterFloat
   , className =? "Xdm-app"                    --> doCenterFloat
   , className =? "java-lang-Thread"            --> doCenterFloat
   , className =? "GParted"                     --> doCenterFloat
   , className =? "install4j-burp-StartBurp"    --> doCenterFloat
   , className =? "viper-gui"                   --> doCenterFloat
   , className =? "Soffice"                     --> doCenterFloat
   , className =? "TIPP10"                      --> doCenterFloat
   , className =? "Gimp-2.10"                   --> (doFullFloat <+> doShift "5")
   , className =? "typingmaster.exe"            --> (doFullFloat <+> doShift "4")
   , className =? "VirtualBox Machine"          --> doShift "4"
   , className =? "VirtualBoxVM"                --> (doFloat <+> doShift "4")
   , className =? "VirtualBox Manager"          --> doShift ( myWorkspaces !! 3 ) 
   , className =? "obsidian"                    --> doShift ( myWorkspaces !! 2)
   , className =? "libreoffice-startcenter"     --> (doFullFloat <+> doShift "4") 
   , className =? "xfreerdp"                    -->  doShift "3"
   , (isFullscreen                              --> doFullFloat)
   ]

main :: IO ()
main = do
  xmproc <- spawnPipe "/usr/bin/xmobar"
  xmonad $ docks $ fullscreenSupportBorder $ ewmh $ def {
            -- simple stuff
     terminal           = myTerminal,
     focusFollowsMouse  = myFocusFollowsMouse,
     clickJustFocuses   = myClickJustFocuses,
     modMask            = myModMask,
     workspaces         = myWorkspaces,
     borderWidth        = myBorderWidth,
     normalBorderColor  = myNormColor,
     focusedBorderColor = myFocusedColor,
    -- key bindings
     keys               = myKeys,
     mouseBindings      = myMouseBindings,
    -- hooks, layouts
     layoutHook         = myLayoutHook,
     handleEventHook    = windowedFullscreenFixEventHook <+> trayerPaddingXmobarEventHook, 
     manageHook         = myManageHook <+> manageDocks <+> manageSpawn, 
     startupHook        = myStartupHook,
     logHook = dynamicLogWithPP xmobarPP                                        -- Status bars and Logging
       { ppOutput = hPutStrLn xmproc
       , ppCurrent = xmobarColor "white" "" . wrap "[""]" . clickable           -- Current workspace in xmobar
       , ppVisible = xmobarColor "#82AAFF" "" . clickable                       -- Visible but not current workspace
       , ppHidden = xmobarColor "#ababab" "" . wrap " " "" . clickable          -- Hidden workspaces in xmobar; !!! Needed for clickability !!!
       -- ppHiddenNoWindows = xmobarColor "#ababab" "" . clickable              -- Hidden workspaces (no windows)
       -- ppTitle = xmobarColor "#b3afc2" "" . shorten 60                       -- Title of active window in xmobar
       , ppSep =  "<fc=#82AAFF> <fn=1> ||</fn> </fc>"                           -- Separators in xmobar
       , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!" . clickable         -- Urgent workspace
       , ppExtras  = [windowCount]                                              --  of windows current workspace
       -- ppOrder = \(ws:l:t:_) -> [ws]
       , ppOrder = \(ws:l:t:ex) -> [ws]++ex
       }
}
