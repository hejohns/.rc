import XMonad
import XMonad.Actions.CycleWS
import XMonad.Config.Xfce
import XMonad.Layout.Grid
import XMonad.Layout.NoBorders
import XMonad.Util.EZConfig

main =
  xmonad
    $ xfceConfig
        { terminal = "xfce4-terminal"
        , layoutHook = myLayoutHook
        , focusedBorderColor = "#800080"
        , borderWidth = 1
        , modMask = mod4Mask
        }
        `additionalKeysP` [ ("M-d", nextScreen)
                          , ("M-a", prevScreen)
                          , ("M-S-d", shiftNextScreen)
                          , ("M-S-a", shiftPrevScreen)
                          ]
  where
    myLayoutHook = Grid ||| (smartBorders $ layoutHook xfceConfig)
