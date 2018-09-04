import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Actions.SpawnOn
import XMonad.Actions.CycleWS
import XMonad.Actions.WindowBringer
import qualified Data.Map as M
import qualified XMonad.StackSet as W
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.Spiral


rofiRun = spawn "rofi -show run"
rofiWindow = spawn "rofi -show window"

keysToAdd x =
    [
        ((modMask x, xK_c), kill)
        ,  ((modMask x, xK_a), prevWS)
        ,  ((modMask x, xK_f), nextWS)
        ,  ((modMask x .|. shiftMask,xK_f), shiftToPrev)
        ,  ((modMask x .|. shiftMask, xK_g), shiftToNext)
        ,  ((modMask x, xK_d), gotoMenu)
        ,  ((modMask x, xK_q), toggleWS)
	,  ((modMask x, xK_s), rofiRun)
	,  ((modMask x, xK_d), rofiWindow)
    ] ++
    [ -- Cycle focus through screens by pressing command w
    ((modMask x, key), sc >>= screenWorkspace >>= flip whenJust (windows . f))
         | (key, sc) <- zip [xK_w, xK_w] [screenBy (-1), screenBy 1]
         , (f, _) <- [(W.view, 0), (W.view, shiftMask)]
    ]

keysToRemove x =
    [
        (modMask x .|. shiftMask, xK_p)
        , (modMask x .|. shiftMask, xK_q)
        , (modMask x, xK_q)
        , (modMask x, xK_w)
        , (modMask x, xK_e)
    ]

  -- Delete the keys combinations we want to remove.
strippedKeys x = foldr M.delete (keys defaultConfig x) (keysToRemove x)

-- Compose all my new key combinations.
myKeys x = M.union (strippedKeys x) (M.fromList (keysToAdd x))

main :: IO ()
main = do
    xmonad $ ewmh defaultConfig
        {modMask = mod4Mask
        ,manageHook = manageDocks <+> manageHook defaultConfig
        ,layoutHook = avoidStruts $ layoutHook defaultConfig
        ,borderWidth = 1
        ,terminal = "lxterminal"
        ,startupHook = setWMName "LG3D"
        ,focusedBorderColor = "#0e1373"
        ,normalBorderColor = "#517cbd"
        ,keys = myKeys
}
