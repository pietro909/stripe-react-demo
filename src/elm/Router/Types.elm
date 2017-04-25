module Router.Types exposing (..)


import Navigation exposing (Location)


type Route
  = Home
  | Edit String
  | Create
  | NotFound


type alias Model =
  { path : String
  , route : Route
  , location : Navigation.Location
  }

type alias ModelOut =
  { path : String
  , page : String
  , location : Navigation.Location
  }

type Msg
  = ChangeLocation String
  | LocationChanged Location

