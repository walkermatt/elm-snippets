-- Based on http://yang-wei.github.io/blog/2016/02/04/a-step-to-step-guide-to-elm-signal/

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

-- Count down clock

type Action = NoOp | Increase | Decrease | Reset

initial = 24

input : Signal Action
input =
  let
      upDown = Signal.map .y Keyboard.arrows
      toAction y =
        if y == 1 then Increase
        else if y == -1 then Decrease
        else NoOp
      action = Signal.map toAction upDown
  in
     Signal.sampleOn (Time.fps 30) action

space : Signal Action
space =
  Signal.map (always Reset) Keyboard.space

time : Signal Action
time =
  Signal.map (always Decrease) (Time.every Time.second)

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
    Increase -> counter + 1
    Decrease -> max 0 (counter - 1)
    Reset -> initial
    NoOp -> counter

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
