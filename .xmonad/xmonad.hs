import Control.Concurrent
import Control.Monad
import Control.Monad.Trans.Class
import Data.List
import Data.Monoid
import Numeric
import System.IO
import System.Process
import XMonad hiding ( (|||) )
import XMonad.Actions.Navigation2D
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.LayoutCombinators
import XMonad.ManageHook
import XMonad.Prompt.XMonad
import XMonad.StackSet
import XMonad.Util.EZConfig
import XMonad.Util.Loggers
import XMonad.Util.Run

launchTerminal ws = case peek ws of
       Nothing -> runInTerm "" "$SHELL"
       Just xid -> terminalInCwd xid

terminalInCwd xid = let
  hex = showHex xid " "
  shInCwd = "'cd $(readlink /proc/$(ps --ppid $(xprop -id 0x" ++ hex
    ++ "_NET_WM_PID | cut -d\" \" -f3) -o pid= | tr -d \" \")/cwd) && $SHELL'"
  in runInTerm "" $ "sh -c " ++ shInCwd

modKey = mod4Mask

baseConfig = def {
  normalBorderColor = colorNormal,
  focusedBorderColor = colorActive,
  borderWidth = 2,
  modMask = modKey,
  layoutHook = layoutsConfig,
  manageHook = def <+> appNameHooks,
  terminal = "urxvt"
  }

floatingWindows = ["Android emulator", "Emulator"]

anyStartsWith str strs = foldl (\a b -> a || b) False $ fmap (isPrefixOf str) strs

appNameHooks = appName >>= \str -> return (anyStartsWith str floatingWindows) --> doFloat

layoutsConfig = emptyBSP ||| Tall nmaster delta ratio ||| Full
  where
    nmaster = 1
    delta = 3/100
    ratio = 1/2

navigation = navigation2D def (xK_w, xK_a, xK_s, xK_d)
  [(modKey, windowGo), (modKey .|. shiftMask, windowSwap)] True

myConfig = navigation baseConfig
    `additionalKeysP`
    [
      -- Shrink 1D layouts, ExpandTowards L 2D layouts
      ("M-h", (sendMessage $ ExpandTowards L) <> (sendMessage $ Shrink)),
      -- Expand 1D layouts, ExpandTowards R 2D layouts
      ("M-l", (sendMessage $ ExpandTowards R) <> (sendMessage $ Expand)),
      ("M-j", sendMessage $ ExpandTowards U),
      ("M-k", sendMessage $ ExpandTowards D),
      ("C-M-h", sendMessage $ ShrinkFrom L),
      ("C-M-l", sendMessage $ ShrinkFrom R),
      ("C-M-j", sendMessage $ ShrinkFrom U),
      ("C-M-k", sendMessage $ ShrinkFrom D),
      ("M-f", sendMessage $ JumpToLayout "Full"),
      ("S-M-<Return>", withWindowSet launchTerminal),
      ("M-c", spawn "chromium"),
      ("M-S-x", xmonadPrompt def),
      ("<XF86AudioRaiseVolume>", spawn "amixer -M sset Master 2%+"),
      ("<XF86AudioLowerVolume>", spawn "amixer -M sset Master 2%-"),
      ("<XF86AudioMute>", spawn "amixer sset Master toggle")]

main = do
  let volCmd = pad "$(amixer -M sget Master | awk '/%/ {print $4;}' | tr -d '[]')"
  xbar <- spawnPipe $ "dzen2 -dock -w 700 -fn 'Hack:size=10' -x 0 -bg \\" ++ colorBg ++ " -ta l"
  dateBar <- spawn $ "while [ 1 ]; do date | echo \"" ++ volCmd ++
    "$(date) \"; sleep 1; done | dzen2 -dock -x 700 -fn 'Hack:size=10' -bg \\" ++ colorBg ++ " -ta r"
  xmonad $ docks myConfig {
    layoutHook = avoidStruts $ layoutHook myConfig,
    manageHook = manageDocks <+> manageHook myConfig, 
    logHook = dynamicLogWithPP myDzenPP { ppOutput = hPutStrLn xbar}
    }

rArr = "/home/mewa/.statusbar_icons/r_arr.xbm"

myDzenPP = def {
  ppWsSep = []
  , ppSep = pad "\x2756"
  , ppCurrent = \x -> wrap ("^bg(" ++ colorActive ++ ")^fg(" ++ colorBg ++ ")") "^fg()^bg()" $ pad x
  , ppHidden = \x -> wrap ("^fg(" ++ colorActive ++ ")") ("^fg()") $ pad x
  , ppHiddenNoWindows = \x -> if read x < 6 then ppHidden myDzenPP x else []
  }

colorBg = "#333333"
colorNormal = "#3A372D"
colorActive = "#ffc107"
