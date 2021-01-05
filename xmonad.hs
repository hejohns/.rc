import XMonad
import XMonad.Config.Xfce

main = xmonad xfceConfig
    {
        terminal = "gnome-terminal"
    }
