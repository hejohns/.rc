import XMonad
import XMonad.Config.Xfce
import XMonad.Layout.NoBorders

main = xmonad xfceConfig
    { terminal = "gnome-terminal"
    , layoutHook = myLayoutHook
    , focusedBorderColor = "#800080"
    , borderWidth = 1
    }
    where
    myLayoutHook = smartBorders $ layoutHook xfceConfig
