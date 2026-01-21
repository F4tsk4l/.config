{-# LANGUAGE LambdaCase #-}
--IMPORT
import XMonad
import XMonad.Prelude
import XMonad.Config.Desktop
import System.Directory
import System.IO
import System.Exit
import Control.Monad
import System.Process (readProcess)
import Numeric (showIntAtBase, readHex)
import qualified XMonad.StackSet as W
import qualified Data.Text as T
import qualified Data.Text.Encoding as TE
import qualified Data.ByteString as BS

-- Graphics
import Graphics.X11.ExtraTypes.XF86
import Graphics.X11.Xlib
import Graphics.X11.Xlib.Extras
import Foreign.C.Types (CLong)

-- Util
import XMonad.Util.Hacks (windowedFullscreenFixEventHook, javaHack, trayerAboveXmobarEventHook, trayAbovePanelEventHook, trayerPaddingXmobarEventHook, trayPaddingXmobarEventHook, trayPaddingEventHook)
import XMonad.Util.Dmenu
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.Run(safeSpawn)
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Cursor
import qualified XMonad.Util.Hacks as Hacks

-- Action
import XMonad.Actions.ToggleFullFloat
import XMonad.Actions.TagWindows
import XMonad.Actions.MouseResize
import XMonad.Actions.WorkspaceNames
import XMonad.Actions.SpawnOn
import XMonad.Actions.CycleWS (moveTo, shiftTo, WSType(..), nextScreen, prevScreen)

-- Layouts
import XMonad.Layout.Accordion
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Reflect (reflectHoriz)

-- Layouts modifiers
import XMonad.Layout.Fullscreen
import XMonad.Layout.LayoutHints
import XMonad.Layout.Gaps
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS, FULL))
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Renamed
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Layout.Simplest
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.Renamed
import XMonad.Layout.ShowWName
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowNavigation
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts)
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))
import XMonad.Layout.NoFrillsDecoration

-- Data
import Data.Word (Word8)
import Foreign.C.Types (CChar)
import Data.Bits ((.|.))
import Data.Word
import Data.List
import Data.Monoid
import Data.Char
import Data.Maybe (isJust, fromJust)
import Data.Tree
import qualified Data.Map as M

-- Hooks
import XMonad.Hooks.RefocusLast (refocusLastLogHook)
import XMonad.Hooks.EwmhDesktops 
import XMonad.Hooks.Focus
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.SetWMName
import XMonad.Hooks.Place
import XMonad.Hooks.XPropManage
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
myTerminal = "kitty"

myFont :: String
myFont = "xft:Font Mono:regular:size=9:antialias=true:hinting=true"

-- Windows border in pixels
myBorderWidth :: Dimension
myBorderWidth = 2

myActiveTextColor :: String
myActiveTextColor = "#06D001"

myInactiveTextColor :: String
myInactiveTextColor = "#BC5A94"

myNormColor :: String
myNormColor  = "#282c34"

myFocusedColor :: String
myFocusedColor = "#46d9ff"

--myEventHook = fullscreenEventHook

--myEventHook :: Event -> X All
--myEventHook (MapNotifyEvent {ev_window = w}) = do
--    setWindowOpacity 0.8 w
--    return (All True)
--myEventHook _ = return (All True)

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = True

-- ModKey
myModMask :: KeyMask
myModMask = mod4Mask

-- MyWorkspaces
myWorkspaces :: [String]
-- myWorkspaces = map show [1..9]
myWorkspaces    = [" 1 "," 2 "," 3 "," 4 "," 5 "," 6 "," 7 "," 8 "," 9 "]

-- Clickable workspaces
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..9] 
clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices

-----------------------------------------------------------
-- KeyBindings
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawnHere $ XMonad.terminal conf)
    -- Reset NSP
    --, ((modm, xK_Return), windows W.swapMaster >> resetFocusedNSP)
    -- launch dmenu
    , ((modm, xK_d), spawn "dmenu_run")
    -- launch lockscreen
    , ((modm .|. controlMask, xK_l), spawn "i3lock --radius 100 -eki ~/Saver/shaded_landscape.png -F --ring-width 3  --time-str='%H:%M' && echo mem > /sys/power/state")
    -- launch gmrun
    --, ((modm .|. shiftMask, xK_p), spawn "gmrun")
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
    -- MY KEYBINDINGS
    -- Decrease window opacity
    , ((modm .|. shiftMask, xK_j), withFocused $ \w -> do
        op <- getWindowOpacity w
        let newOp = max 0.1 (op - 0.1)
        setWindowOpacity newOp w)

    -- Increase window opacity
    , ((modm .|. shiftMask, xK_k), withFocused $ \w -> do
        op <- getWindowOpacity w
        let newOp = min 1.0 (op + 0.1)
        setWindowOpacity newOp w)

    , ((modm .|. shiftMask, xK_Down), withFocused (\w -> spawn $ "xprop -id " ++ show w ++ " -f _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY 0xDAFFFFFF"))
    -- Reset to full opacity
    , ((modm .|. shiftMask, xK_Up), withFocused (\w -> spawn $ "xprop -id " ++ show w ++ " -remove _NET_WM_WINDOW_OPACITY"))

    -- Quit xmonad
    --, ((modm .|. shiftMask, xK_c), io (exitWith ExitSuccess))
    --, ((modm .|. shiftMask, xK_c), spawn "mate-session-save --logout-dialog")
    , ((modm .|. shiftMask, xK_c), spawn "~/.local/bin/powermenu")
    -- Restart xmonad
    , ((modm, xK_q), spawn "xmonad --recompile; xmonad --restart")
    , ((modm .|. shiftMask, xK_p), spawn "~/.local/bin/powermenu")
    -- Jamesdsp start 
    , ((modm .|. shiftMask, xK_v), spawn "jamesdsp -t")
    , ((modm, xK_n), spawnHere "nemo")
    --, ((modm .|. controlMask, xK_b), sendMessage ToggleStruts)
    , ((modm , xK_p), spawn "deadd") 
    --, ((modm, xK_f), withFocused toggleFullFloat)
    -- Fullscreen Toggle
    , ((modm, xK_f), sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts)
    -- Browsers
    , ((modm .|. shiftMask, xK_f), spawnHere "firefox")
    , ((modm .|. shiftMask, xK_b), spawnHere "brave")
    , ((modm .|. controlMask, xK_b), spawnHere "brave --incognito")
    , ((modm .|. shiftMask, xK_l), spawnHere "librewolf")
    -- ScratchPads
    , ((modm .|. shiftMask, xK_s), withFocused $ toggleDynamicNSP "dny1")
    , ((modm, xK_s), dynamicNSPAction "dny1")
    , ((modm .|. shiftMask, xK_t), spawnHereNamedScratchpadAction myScratchPads "thunderbird")
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
    -- Pavucontrol
    , ((modm .|. controlMask, xK_m), spawn "pavucontrol")
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
-- NOTE: 
--Toggle full testing
toggleFull = withFocused (\windowId -> do
    { floats <- gets (W.floating . windowset);
        if windowId `M.member` floats
        then withFocused $ windows . W.sink
        else withFocused $ windows . (flip W.float $ W.RationalRect 0 0 1 1) })  
--NOTE:
-- OPACITY
-- Set window opacity (0.0 to 1.0)
setWindowOpacity :: Rational -> Window -> X ()
setWindowOpacity opacity w = withDisplay $ \dpy -> do
    let prop = "_NET_WM_WINDOW_OPACITY"
    a <- io $ internAtom dpy prop False
    let val = round (opacity * fromIntegral (0xffffffff :: Word32)) :: CLong
    io $ changeProperty32 dpy w a a propModeReplace [fromIntegral val]
    io $ flush dpy
    io $ sync dpy False

-- Get current opacity, default to 1.0
getWindowOpacity :: Window -> X Rational
getWindowOpacity w = withDisplay $ \dpy -> do
    a <- io $ internAtom dpy "_NET_WM_WINDOW_OPACITY" False
    mbr <- io $ getWindowProperty32 dpy a w
    let op = case mbr of
                Just [val] -> fromIntegral val / fromIntegral (maxBound :: Word32)
                _          -> 0.8
    return op

 --My spacing; n sets the gap size around the windows.
------------------------------------------------------
tall     = renamed [Replace "tall"]
           $ limitWindows 5
           $ mySpacing 2
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (Simplest)
           $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "monocle"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ Full
--floats   = renamed [Replace "floats"]
--           $ smartBorders
--           $ simplestFloat
--grid     = renamed [Replace "grid"]
--           $ limitWindows 9
--           $ smartBorders
--           $ windowNavigation
--           $ addTabs shrinkText myTabTheme
--           $ subLayout [] (smartBorders Simplest)
--           $ mySpacing 2
--           $ mkToggle (single MIRROR)
--           $ Grid (16/10)
--spirals  = renamed [Replace "spirals"]
--           $ limitWindows 9
--           $ smartBorders
--           $ windowNavigation
--           $ addTabs shrinkText myTabTheme
--           $ subLayout [] (smartBorders Simplest)
--           $ mySpacing 2
--           $ spiral (6/7)
--threeCol = renamed [Replace "threeCol"]
--           $ limitWindows 7
--           $ smartBorders
--           $ windowNavigation
--           $ addTabs shrinkText myTabTheme
--           $ subLayout [] (smartBorders Simplest)
--           $ ThreeCol 1 (3/100) (1/2)
--threeRow = renamed [Replace "threeRow"]
--           $ limitWindows 7
--           $ smartBorders
--           $ windowNavigation
--           $ addTabs shrinkText myTabTheme
--           $ subLayout [] (smartBorders Simplest)
--           -- Mirror takes a layout and rotates it by 90 degrees.
--           -- So we are applying Mirror to the ThreeCol layout. $ Mirror $ ThreeCol 1 (3/100) (1/2)
tabs     = renamed [Replace "tabs"]
           -- I cannot add spacing to this layout because it will
           -- add spacing between window and tabs which looks bad.
           $ tabbed shrinkText myTabTheme
--tallAccordion  = renamed [Replace "tallAccordion"]
--           $ Accordion
--wideAccordion  = renamed [Replace "wideAccordion"]
--           $ Mirror Accordion

-----------------------------------------------------
myTabTheme = def { fontName            = myFont
                 , activeColor         = myFocusedColor
                 , inactiveColor       = myNormColor
                 , activeBorderColor   = myFocusedColor
                 , inactiveBorderColor = myNormColor
                 , activeTextColor     = myActiveTextColor
                 , inactiveTextColor   = myInactiveTextColor
                 }

myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
  { swn_font              = "xft:Ubuntu:bold:size=30"
  , swn_fade              = 0.3
  , swn_bgcolor           = "#1c1f24"
  , swn_color             = "#ffffff"
  }
 

-- Layouts:
-- OtherIndicated
-- OnlyScreenFloat
-- OnlyLayoutFloatBelow
-- lessBorders OnlyFloat
--myLayoutHook = lessBorders OnlyScreenFloat $ avoidStruts $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
--myLayoutHook = avoidStruts $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
myLayoutHook = lessBorders OnlyScreenFloat $ avoidStruts $ mouseResize $ windowArrange $ mkToggle (NBFULL ?? MIRROR ?? NOBORDERS ?? FULL ?? EOT) myDefaultLayout
  where
    myDefaultLayout = tall
                   ||| noBorders monocle
                   ||| tabs
--                 ||| floats
--                 ||| grid
--                 ||| spirals
--                 ||| threeCol
--                 ||| threeRow
--                 ||| tallAccordion
--                 ||| wideAccordion
--myLayoutHook  = avoidStruts (withBorder 2 tiled ||| Mirror tiled ||| Full)
--    where
--        tiled   = lessBorders OnlyFloat (Tall nmaster delta ratio)
--        nmaster = 1      -- Default number of windows in the master pane
--        ratio   = 1/2    -- Default proportion of screen occupied by master pane
--        delta   = 3/100  --

-- SCRATCHPADS
myScratchPads :: [NamedScratchpad]
myScratchPads = [ 
                  NS "thunderbird" spawnMail findMail manageMail
                --, NS "mocp" spawnMocp findMocp manageMocp
                --, NS "calculator" spawnCalc findCalc manageCalc
                ]
                                  
  where
    spawnMail  = "thunderbird" ++ " -t scratchpad"
    findMail   = className =? "thunderbird"
    manageMail = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
--    spawnTerm  = myTerminal ++ " -t scratchpad"
--    findTerm   = title =? "scratchpad"
--    manageTerm = customFloating $ W.RationalRect l t w h
--               where
--                 h = 0.9
--                 w = 0.9
--                 t = 0.95 -h
--                 l = 0.95 -w
--    spawnMocp  = myTerminal ++ " -t mocp -e mocp"
--    findMocp   = title =? "mocp"
--    manageMocp = customFloating $ W.RationalRect l t w h
--               where
--                 h = 0.9
--                 w = 0.9
--                 t = 0.95 -h
--                 l = 0.95 -w


--Makes setting the spacingRaw simpler to write. The spacingRaw module adds a configurable amount of space around windows.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- WS Window Count
windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

-- MyStartup Hooks
myStartupHook :: X ()
myStartupHook = do
   spawnOnce "/usr/lib/mate-polkit/polkit-mate-authentication-agent-1"
   spawnOnce "picom"
   spawnOnce "mpd"
   spawnOnce "mate-power-manager"
   setWMName "LG3D"
   spawnOnce "Pipewire"
   spawnOnce "trayer --edge top --distance 0 --align right --widthtype request --iconspacing 2 --SetDockType true --padding 2 --expand True --monitor 1 --transparent true --alpha 100 --tint 0xff000000 --height 17"
   spawnOnce "nitrogen --restore"
   spawnOnce "jamesdsp -t"
   spawnOnce "env GTK_USE_PORTAL=1 '/opt/xdman/xdm-app' --background"
   spawnOnce "qbittorrent"
   spawnOnce "/usr/bin/deadd-notification-center"
   spawnOnce "start_conky_maia"
   spawnOnce "nm-applet"
   spawnOnce "pasystray -g"
   --spawnOnce "xautolock -time 30 -locker 'i3lock --radius 100 -eki ~/Saver/shaded_landscape.png -F --ring-width 3  --time-str='%H:%M' && echo mem > /sys/power/state' -detectsleep -killtime 60 -killer 'mate-session-save --logout'"
   --spawnOnce "mate-session"
   --setWMName "xmonad"
   --setWMName "LG3D"
   --spawnOnce "exec xhost +SI:localuser:$USER &"
--NOTE:
setTransparentHook :: Event -> X All
setTransparentHook ConfigureEvent{ev_event_type = createNotify, ev_window = win} = do
  let ignoreApps = ["mpv", "vlc", "feh", "librewolf", "Gimp", "Brave-browser", "Zathura", "Ferdium", "pdfeditor.exe", "pdflauncher.exe",  "libreoffice", "libreoffice-writer", "libreoffice-startcenter", "winecfg.exe", "Inkscape"]  -- apps to ignore (class names)

  dpy <- asks display
  classHint <- io $ getClassHint dpy win
  let cls = resClass classHint

  if map toLower cls `notElem` map (map toLower) ignoreApps
    then setOpacity win
    else return ()
    
  return (All True)
  where
    opacityFloat = 0.85
    opacity = floor $ fromIntegral (maxBound :: Word32) * opacityFloat
    setOpacity w = spawn $ "xprop -id " ++ show w ++
                           " -f _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY " ++ show opacity

setTransparentHook _ = return (All True)
--getWindowTitle :: Display -> Window -> IO String
--getWindowTitle dpy w = do
--  prop <- getTextProperty dpy w wM_NAME
--  wcTextPropertyToTextList dpy prop >>= \case
--    (x:_) -> return x
--    []    -> return ""
--
--setTransparentHook :: Event -> X All
--setTransparentHook ConfigureEvent{ev_event_type = createNotify, ev_window = win} = do
--  let blockTitles = ["youtube", "stream", "superabbit77", "sd0embed", "viprow",
--                     "freesports", "1stream", "buffstreams", "watch", "facebook",
--                     "x", "blob"]
--
--  dpy <- asks display
--
--  -- Get title and class
--  classHint <- io $ getClassHint dpy win
--  let cls = map toLower $ resClass classHint
--
--  title <- io $ getWindowTitle dpy win
--  let titleLower = map toLower title
--
--  -- Check for blocked titles
--  let blocked = any (`isInfixOf` titleLower) blockTitles
--
--  when (not blocked) $
--    setOpacity win
--
--  return (All True)
--  where
--    opacityFloat = 0.85
--    opacity = floor $ fromIntegral (maxBound :: Word32) * opacityFloat
--    setOpacity w = spawn $ "xprop -id " ++ show w ++
--                           " -f _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY " ++ show opacity
--
--setTransparentHook _ = return (All True)
--xPropMatches :: [XPropMatch]
--xPropMatches = [ --([ (wM_CLASS, any ("explorer.exe"==))], (\w -> float w >> return (W.shift "2")))
--               --, ([ (wM_COMMAND, any ("screen" ==)), (wM_CLASS, any ("xterm" ==))], pmX (addTag "screen"))
--                ([ (wM_NAME, any ("MavisBeacon" `isInfixOf`))], pmX (addTag "Beacon"))
--                --([ (wM_NAME, any ("MavisBeacon" `isInfixOf`))], (\w -> float w >> return (W.shift "2")))
--               ]

-- WINDOW RULES
myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
   [ resource  =? "desktop_window"              --> doIgnore
   , title     =? "* Properties"                --> doCenterFloat
   , title     =? "* joinhoney"                 --> doCenterFloat
   , title     =? "Library"                     --> doCenterFloat
   , title     =? "Text search"                 --> doCenterFloat
   , title     =? "Choose an icon"              --> doCenterFloat
   , title     =? "Navigator"                   --> doCenterFloat
   , resource  =? "libreoffice-writer"          --> doFullFloat <+> doShift (myWorkspaces !! 4)
   , appName   =? "libreoffice-writer"          --> doFullFloat <+> doShift (myWorkspaces !! 4)
   , title     =? "libreoffice-writer"          --> doFullFloat <+> doShift (myWorkspaces !! 4)
   , className =? "libreoffice-writer"          --> doFullFloat <+> doShift (myWorkspaces !! 4) 
   , appName   =? "libreoffice"                 --> doFullFloat <+> doShift (myWorkspaces !! 4)
   , appName   =? "cmst"                        --> doCenterFloat
   , title     =? "MavisBeacon.exe - Wine Desktop"  --> doCenterFloat
   , appName   =? "Msgcompose"                  --> doCenterFloat
   , appName   =? "file_properties"             --> doCenterFloat
   , appName   =? "Calendar"                    --> doCenterFloat
   , appName   =? "Dark Reader developer tools" --> doCenterFloat
   , className =? "conky"                       --> doIgnore
   -- TODO:Add MavisBeacon to doCenterFloat
   --, title     =? "MavisBeacon.exe - Wine desktop"  --> doCenterFloat
   --, title     =? "MavisBeacon.exe *"               --> doCenterFloat
   --, className =? "Explorer.exe               --> doCenterFloat
   --, className =? "winecfg.exe"               --> doCenterFloat
   , className =? "Navigator"                   --> doCenterFloat
   , className =? "trayer"                      --> doIgnore
   , className =? "Xfce4-notifyd"               --> doIgnore
   , className =? "deadd-notification-center"   --> doIgnore
   , className =? "Nitrogen"                    --> doCenterFloat
   , className =? "PacketTracer"                --> doCenterFloat
   , className =? "Browser"                     --> doCenterFloat
   , className =? "qBittorrent"                 --> doCenterFloat
   , className =? "cmst"                        --> doCenterFloat
   , className =? "pavucontrol"                 --> doCenterFloat
   , className =? "jamesdsp"                    --> doCenterFloat
   , className =? "Xdm-app"                     --> doCenterFloat
   , className =? "Uget-gtk"                    --> doCenterFloat
   , className =? "java-lang-Thread"            --> doCenterFloat
   , className =? "GParted"                     --> doCenterFloat
   , className =? "install4j-burp-StartBurp"    --> doCenterFloat
   , className =? "viper-gui"                   --> doCenterFloat
   , className =? "Blueman-manager"             --> doCenterFloat
   , className =? "Soffice"                     --> doCenterFloat
   , className =? "TIPP10"                      --> doCenterFloat
   , className =? "Gimp"                        --> doCenterFloat <+> doShift (myWorkspaces !! 4)
   , className =? "Gimp-3.0"                    --> doCenterFloat <+> doShift (myWorkspaces !! 4)
   --, className =? "libreoffice"               --> doFullFloat <+> doShift (myWorkspaces !! 4) 
   --, className =? "libreoffice"               --> doShift (myWorkspaces !! 4) 
   --, className =? "libreoffice-writer"        --> doShift (myWorkspaces !! 4) 
   , className =? "VirtualBoxVM"                --> doShift (myWorkspaces !! 4) 
   , className =? "Inkscape"                    --> doShift (myWorkspaces !! 3)
   , className =? "whatsdesk"                   --> doShift (myWorkspaces !! 2) 
   , className =? "VirtualBox Machine"          --> doShift (myWorkspaces !! 3)
   , className =? "VirtualBox Manager"          --> doShift (myWorkspaces !! 3) 
   , className =? "obsidian"                    --> doShift (myWorkspaces !! 2)
   , className =? "xfreerdp"                    --> doShift (myWorkspaces !! 2)
   , isFullscreen                               --> (doFullFloat)
   --, isFullscreen                                --> (doF W.focusDown <+> doFullFloat)
   ]
--NOTE:
-- | ManageHook to apply default opacity on window creation
doSetInitialOpacity :: Rational -> ManageHook
doSetInitialOpacity op = ask >>= \w -> liftX (setWindowOpacity op w) >> idHook

main :: IO ()
main = do
--  fullscreenRef <- newIORef True
  xmproc <- spawnPipe "/usr/bin/xmobar"
  --xmonad  $ docks $ fullscreenSupportBorder $ xfceConfig {
  xmonad  $ docks $ ewmhFullscreen . ewmh $ desktopConfig {
       terminal           = myTerminal
     , focusFollowsMouse  = myFocusFollowsMouse
     , clickJustFocuses   = myClickJustFocuses
     , modMask            = myModMask
     , workspaces         = myWorkspaces
     , borderWidth        = myBorderWidth
     , normalBorderColor  = myNormColor
     , focusedBorderColor = myFocusedColor
     , keys               = myKeys
     , mouseBindings      = myMouseBindings
     , layoutHook         = showWName' myShowWNameTheme $ myLayoutHook 
     --, handleEventHook    = fullscreenEventHook
     , handleEventHook    = handleEventHook def <+> setTransparentHook <+> Hacks.windowedFullscreenFixEventHook <+> Hacks.trayerAboveXmobarEventHook <+> trayerPaddingXmobarEventHook
     --, manageHook         = myManageHook <+> manageDocks <+> manageSpawn <+> namedScratchpadManageHook myScratchPads
     --, manageHook         = myManageHook <+> manageDocks <+> manageSpawn <+> manageHook mateConfig <+> namedScratchpadManageHook myScratchPads
     , manageHook         = myManageHook <+> manageDocks <+> manageSpawn <+> namedScratchpadManageHook myScratchPads
      --manageHook         = myManageHook <+> manageDocks <+> manageSpawn <+> fullscreenManageHook <+> xPropManageHook xPropMatches
     , startupHook        = myStartupHook
     , logHook = dynamicLogWithPP $ filterOutWsPP [scratchpadWorkspaceTag] $ xmobarPP -- Status bars and Logging
       { ppOutput = hPutStrLn  xmproc
       , ppCurrent = xmobarColor "#59D5E0" "" . wrap 
                 ("<box type=Bottom width=2 mb=1 color=#06D001>") "</box>" . clickable      -- Current workspace in xmobar
       , ppVisible = xmobarColor "#219C90" "" . clickable                                               -- Visible but not current workspace
       , ppHidden = xmobarColor "#219C90" "" . wrap                                                   -- Hidden workspaces in xmobar; !!! Needed for clickability !!!
                 ("<box type=Bottom width=2 mb=1 color=" ++ myInactiveTextColor ++ ">") "</box>" . clickable    -- Current workspace in xmobar
       , ppHiddenNoWindows = xmobarColor "#ababab" "" . clickable                                               -- Hidden workspaces (no windows)
       , ppTitle = xmobarColor "#b3afc2" "" . shorten 20                                                        -- Title of active window in xmobar
       , ppSep =  "<fc=" ++ myFocusedColor ++ "><fn=1>  / </fn> </fc>"                                            -- Separators in xmobar
       , ppUrgent = xmobarColor "#F80000" "" . wrap                                                             -- Urgent workspace
                 ("<box type=Bottom width=2 mb=1 color=#F80000>") "</box>" . clickable                          -- Current workspace in xmobar
       , ppExtras  = [windowCount]                                                                              --  of windows current workspace
       -- ppOrder = \(ws:l:t:_) -> [ws]
       , ppOrder = \(ws:l:t:ex) -> [ws,l]++ex++[t]
       } 
}
