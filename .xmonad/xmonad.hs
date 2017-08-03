import XMonad hiding ( (|||) )
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.Spiral
import XMonad.Layout.Accordion
import XMonad.Layout.BinarySpacePartition
import XMonad.Actions.Navigation2D
import XMonad.Util.EZConfig
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run
import XMonad.Prompt.XMonad
import Data.Monoid
import System.IO
import XMonad.Hooks.ManageDocks
import Numeric
import Control.Monad.Trans.Class
import Control.Monad
import XMonad.Util.Loggers
import Control.Concurrent
import Data.List
import System.Process

modKey = mod4Mask

baseConfig = def {
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
      ("M-c", spawn "chromium"),
      ("M-S-x", xmonadPrompt def),
      ("<XF86AudioRaiseVolume>", spawn "amixer sset Master 2%+"),
      ("<XF86AudioLowerVolume>", spawn "amixer sset Master 2%-"),
      ("<XF86AudioMute>", spawn "amixer sset Master toggle")]

main = do
  xbar <- spawnPipe $ "dzen2 -dock -w 700 -fn 'Hack:size=10' -x 0 -bg \\" ++ colorBg ++ " -ta l"
  dateBar <- spawn $ "while [ 1 ]; do date | echo \"$(date) \"; sleep 1; done | dzen2 -dock -x 700 -fn 'Hack:size=10' -bg \\" ++ colorBg ++ " -ta r"
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
colorActive = "#ffc107"
