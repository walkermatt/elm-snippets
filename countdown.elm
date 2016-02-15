module Main (..) where

import Graphics.Element exposing (..)
import Time
import Keyboard
import Window
import Text
import Color
import Html
import Html.Events as Events
import Html.Attributes exposing (style)


type Action
  = Reset
  | Add Int



-- Intial value of our counter


initial =
  24



-- Signal of arrow key generated Actions


arrows : Signal Action
arrows =
  let
    arrowToAction =
      Signal.map (\arrows -> Add arrows.y) Keyboard.arrows
  in
    Signal.sampleOn (Time.fps 30) arrowToAction


space : Signal Action
space =
  Signal.map (always Reset) Keyboard.space


time : Signal Action
time =
  Signal.map (\time -> Add -1) (Time.every Time.second)


mb : Signal.Mailbox Action
mb =
  Signal.mailbox Reset


actions : Signal Action
actions =
  Signal.mergeMany [ time, arrows, space, mb.signal ]


clock : Signal Int
clock =
  Signal.foldp update initial actions


update : Action -> Int -> Int
update action counter =
  case action of
    Add n ->
      max 0 (counter + n)

    Reset ->
      initial


view : Signal.Address Action -> ( Int, Int ) -> Int -> Html.Html
view address ( w, h ) time =
  Html.div
    []
    [ Html.span [ (counterStyle time) ] [ Html.text (toString time) ]
    , Html.button
        [ Events.onClick address Reset ]
        [ Html.text "Reset" ]
    ]


counterStyle : Int -> Html.Attribute
counterStyle time =
  style
    [ ( "color"
      , (if time == 0 then
          "#FF0000"
         else
          "#333333"
        )
      )
    , ( "font-weight", "bold" )
    , ( "display", "inline-block" )
    , ( "width", "2em" )
    ]


main : Signal Html.Html
main =
  Signal.map2 (view mb.address) Window.dimensions clock
