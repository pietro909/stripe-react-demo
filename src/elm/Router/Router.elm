module Router.Router exposing (..)


import UrlParser as UP
import UrlParser exposing ((</>), s)
import Navigation

import Router.Types exposing (..)
import Router.Ports as Ports


initialModel : Navigation.Location -> Model
initialModel location =
  { path = location.pathname
  , route = parseLocation location
  , location = location
  }

init : Navigation.Location -> (Model, Cmd Msg)
init location =
  let
    msg = LocationChanged location
  in
    update msg <| initialModel location

matchers : UP.Parser (Route -> a) a
matchers =
  UP.oneOf
    [ UP.map Home UP.top
    , UP.map Edit (s "edit" </> UP.string)
    , UP.map Create (s "create")
    ]


parseLocation : Navigation.Location -> Route
parseLocation location =
  case (UP.parsePath matchers location) of
    Just route ->
      Debug.log "parsed location" route
    Nothing ->
      NotFound


routeToString : Route -> String
routeToString route =
  case route of
    Home ->
      "List"
    Edit id ->
      "Form"
    Create ->
      "Form"
    NotFound ->
      "NotFound"


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ChangeLocation path ->
      ( model, Navigation.newUrl path )

    LocationChanged location ->
      let
          newRoute = parseLocation location
          newModel = Model location.pathname newRoute location
          cmd =
            ModelOut newModel.path (routeToString newModel.route) newModel.location
            |> Ports.destination
      in
          (newModel, cmd)

subscriptions : Model -> Sub Msg
subscriptions model =
  Ports.navigateToUrl ChangeLocation
