import XMonad
import XMonad.Layout.Spiral
import XMonad.Layout.Accordion
import XMonad.Layout.BinarySpacePartition
import XMonad.Actions.Navigation2D
import XMonad.Util.EZConfig
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run
import Data.Monoid
import System.IO

modKey = mod4Mask

baseConfig = def {
  focusedBorderColor = "#ffc107",
  borderWidth = 2,
  modMask = modKey,
  layoutHook = layoutsConfig,
  terminal = "gnome-terminal"
  }
  
layoutsConfig = emptyBSP ||| Tall nmaster delta ratio ||| Full
  where
    nmaster = 1
    delta = 3/100
    ratio = 1/2

navigation = navigation2D def (xK_w, xK_a, xK_s, xK_d)
  [(modKey, windowGo), (modKey .|. shiftMask, windowSwap)] True

main = do
  xmonad =<< statusBar "lemonbar -p" def def (navigation baseConfig
    `additionalKeysP`
      [("M-h", (sendMessage $ ExpandTowards L) <> (sendMessage $ Shrink)), -- Shrink unidirectional layouts, ExpandTowards bidirectional
      ("M-l", (sendMessage $ ExpandTowards R) <> (sendMessage $ Expand)),
      ("M-j", sendMessage $ ExpandTowards U),
      ("M-k", sendMessage $ ExpandTowards D),
      ("C-M-h", sendMessage $ ShrinkFrom L),
      ("C-M-l", sendMessage $ ShrinkFrom R),
      ("C-M-j", sendMessage $ ShrinkFrom U),
      ("C-M-k", sendMessage $ ShrinkFrom D)]
                                                          )
