module Router.Router exposing (..)


import UrlParser as UP

import Router.Types exposing (..)
import Router.Ports as Ports


matchers : UP.Parser (Route -> a) a
matchers =
  UP.oneOf
    [ UP.map Home UP.top
    , UP.map Edit (UP.s "edit" </> UP.string)
    ]


parseLocation : Navigation.Location -> Route
parseLocation location =
  case (UP.parsePath matchers location) of
    Just route ->
      route

    Nothing ->
      NotFound


update : Msg -> Model -> (Model, Cmd.Msg)
update msg model =
  case msg of
    ChangeLocation path ->
i      ( model, Navigation.newUrl path )

    LocationChanged location ->
      let
        newRoute = parseLocation location
        page = getPage newRoute
        newModel = { path = location.pathName, page = page }
        cmd = Ports.destination newModel
      in
        ({ model = newModel }, Cmd.none )


getPage : Route -> String
getPage route =
  case route of
    Home ->
      "List"
    Edit id ->
      "Edit"
    Create ->
      "Create"
    NotFound
      "NotFound"
