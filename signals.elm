-- Based on http://yang-wei.github.io/blog/2016/02/04/a-step-to-step-guide-to-elm-signal/
-- Compile with `elm-make signals.elm --output signals.html`

import Graphics.Element exposing (..)
import Mouse
import Time
import Keyboard
import Char
import Window
import Text
import Color

-- Mouse postion

-- main : Signal Element
-- main =
--     Signal.map show Mouse.position

-- Time

-- main : Signal Element
-- main =
--     Signal.map show (Time.every Time.second)

-- Keys presses

-- main : Signal Element
-- main =
--     Signal.map show (Signal.map Char.fromCode Keyboard.presses)

-- Arrow keys

-- main : Signal Element
-- main =
--     Signal.map show Keyboard.arrows

-- Spacebar

-- main : Signal Element
-- main =
--     Signal.map show Keyboard.space

-- Window dimensions

-- main : Signal Element
-- main =
--     Signal.map show (Window.dimensions)

-- Centred timestamp

-- view : (Int, Int) -> Float -> Element
-- view (w, h) time =
--   toString time
--   |> Text.fromString
--   |> Text.height 50
--   |> centered
--   |> container w h middle

-- main : Signal Element
-- main =
--     Signal.map2 view Window.dimensions (Time.every Time.second)

-- Countdown clock

type Action = Reset | Add Int

-- Default intial value of our counter
initial = 24

-- Signal of arrow key generated Actions
input : Signal Action
input =
  let
    arrowToAction = Signal.map (\arrows -> Add arrows.y) Keyboard.arrows
  in
     -- Use Single.sampleOn to trigger an Action at a rate of 30 frames per
     -- second, when the arrow keys are not down the value will be (Add 0), when
     -- down it will repeat (Add -1) or (Add 1) depending on which arrow, this
     -- allows the user to hold down an arrow key instead of continually
     -- pressing the arrow key
     Signal.sampleOn (Time.fps 30) arrowToAction

space : Signal Action
space =
  Signal.map (always Reset) Keyboard.space

time : Signal Action
time =
  Signal.map (\time -> Add -1) (Time.every Time.second)

actions : Signal Action
actions =
  Signal.mergeMany [time, input, space]

clock : Signal Int
clock =
  Signal.foldp update initial actions

-- Called by foldp with current Action and current counter value, update
-- returns the new counter value based on the Action and the current value
update : Action -> Int -> Int
update action counter =
  case action of
    Add n -> max 0 (counter + n)
    Reset -> initial

view : (Int, Int) -> Int -> Element
view (w, h) time =
  toString time
  |> Text.fromString
  |> Text.height 50
  |> Text.color (if time == 0 then Color.red else Color.black)
  |> centered
  |> container w h middle

main : Signal Element
main =
  Signal.map2 view Window.dimensions clock
