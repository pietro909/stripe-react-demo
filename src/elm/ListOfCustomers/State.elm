module State exposing (init, update, subscriptions)

import Types exposing (..)

initialModel : Model
initialModel =
  { customers = [] }

init : (Model, Cmd Msg)
init =
  ( initialModel, Cmd.none )

