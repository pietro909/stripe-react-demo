port module ElmApp exposing (main)

import Html exposing (Html, div, text)

import Api
import Models exposing (..)
import Messages exposing (..)

port customers : List Customer -> Cmd msg

port addCustomer : (String -> msg) -> Sub msg
port updateList : (() -> msg) -> Sub msg

type alias Model =
  { customers : List Customer
  , error: String
  }

initialModel : Model
initialModel =
  { customers = [], error = ""}

init : String -> (Model, Cmd Msg)
init flags =
  ( initialModel, Cmd.none )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Customers (Err e) ->
      let
        newModel = { model | error = Debug.log "e" (toString e) }
      in
        (newModel, Cmd.none)
    Customers (Ok list) ->
      let
        newModel = { model | customers = Debug.log "customers" list }
        cmd = customers list
      in
        ( newModel, cmd ) 
    AddCustomer name ->
      let
        --newModel = { model | customers = model.customers ++ [ name ] }
        cmd = Api.create (Customer 10 "hey" "lil_p83@hotmail.com" name "" name)
      in
        ( model, cmd )
    UpdateList ->
      let cmd = Api.readAll
      in
        ( model, cmd)
    CustomerCreated id ->
      ( model, Api.readAll )

view : Model -> Html Msg
view model =
  div [] [ text "Done" ]

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ addCustomer AddCustomer
    , updateList (\_ -> UpdateList)
    ]

main : Program String Model Msg
main =
  Html.programWithFlags
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
