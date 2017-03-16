port module ElmApp exposing (main)

import Html exposing (Html, div, text)

port customers : List String -> Cmd msg

port addCustomer : (String -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
  addCustomer AddCustomer

type alias Model =
  { customers : List String }

init : String -> (Model, Cmd Msg)
init flags =
  ( Model [], Cmd.none )

type Msg
  = Customers (List String)
  | AddCustomer String

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Customers list ->
      let
        newModel = { model | customers = list }
        cmd = customers list
      in
        ( newModel, cmd ) 
    AddCustomer name ->
      let
        newModel = { model | customers = model.customers ++ [ name ] }
        cmd = customers newModel.customers
      in
        ( newModel, cmd ) 

view : Model -> Html Msg
view model =
  div [] [ text "Done" ]

main : Program String Model Msg
main =
  Html.programWithFlags
    { init = init
    , view = view
    , update = update
    , subscriptions = (\_ -> addCustomer AddCustomer)
    }
