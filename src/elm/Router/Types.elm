module Router.Types exposing (..)


import Navigation exposing (Location)


type Route
  = Home
  | Edit String
  | Create
  | NotFound


type alias Model =
  { path : String
  , page : String
  }

type Msg
  = ChangeLocation String
  | LocationChanged Location
