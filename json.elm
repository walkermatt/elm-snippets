-- Compile with `elm-make json.elm --output json.html`
import Graphics.Element exposing (..)
import Json.Decode as Json

-- JSON data to work with
s = "{\"meta\": {\"status\": 200, \"msg\": \"I'm cool!\"}}"

-- Returns a decoder function used by Json.decodeString
f = Json.at ["meta", "msg"] Json.string

-- Json.decodeString returns a Result which is and error value (Ok or Err) and a value, use Result.withDefault to get the value or a default value if the Result represents an error
getMsg =
  Result.withDefault "Oh no!" (Json.decodeString f s)

main =
  show getMsg
