import XMonad
import XMonad.Config.Xfce
import XMonad.Layout.NoBorders
import XMonad.Actions.CycleWS
import XMonad.Util.EZConfig

main = xmonad $ xfceConfig
    { terminal = "xfce4-terminal"
    , layoutHook = myLayoutHook
    , focusedBorderColor = "#800080"
    , borderWidth = 1
    }
    `additionalKeysP`
    [ ("M-d", nextScreen)
    , ("M-a", prevScreen)
    , ("M-S-d", shiftNextScreen)
    , ("M-S-a", shiftPrevScreen)
    ]
    where
    myLayoutHook = smartBorders $ layoutHook xfceConfig
