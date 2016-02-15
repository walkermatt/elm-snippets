-- Based on http://www.elm-tutorial.org/signals/mailboxes.html
-- Compile with `elm-make mailboxes.elm --output mailboxes.html`


module Main (..) where

import Html
import Html.Events as Events


view : Signal.Address String -> String -> Html.Html
view address message =
  Html.div
    []
    [ Html.div [] [ Html.text message ]
    , Html.button
        [ Events.onClick address "Hello" ]
        [ Html.text "Click" ]
    ]


mb : Signal.Mailbox String
mb =
  Signal.mailbox ""


main : Signal Html.Html
main =
  Signal.map (view mb.address) mb.signal
