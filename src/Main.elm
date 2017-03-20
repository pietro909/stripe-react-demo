port module ElmApp exposing (main)

import Html exposing (Html, div, text)
import List.Extra as Lx

import Api exposing (..)
import Models exposing (..)
import Messages exposing (..)

port errors : List String -> Cmd msg
port customers : List Customer -> Cmd msg
port customerInTheEditor : Customer -> Cmd msg

port createCustomer : (Customer -> msg) -> Sub msg
port updateCustomer : (Customer -> msg) -> Sub msg
port deleteCustomer : (Customer -> msg) -> Sub msg
port selectCustomer : (String -> msg) -> Sub msg
port updateList : (() -> msg) -> Sub msg

type alias Model =
  { customers : List Customer
  , customerInTheEditor : Customer
  , errors: List String
  , api: API
  }

type alias Flags =
  { apiKey : String }

initialModel : Flags -> Model
initialModel flags =
  { customers = []
  , customerInTheEditor = emptyCustomer 
  , errors = []
  , api = getAPI flags.apiKey
  }

init : Flags -> (Model, Cmd Msg)
init flags =
  ( initialModel flags, Cmd.none )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Customers (Err e) ->
      let
        newModel = { model | errors = (toString e)::model.errors }
      in
        (newModel, Cmd.none)
    Customers (Ok list) ->
      let
        newModel = { model | customers = list }
        cmd = customers list
      in
        ( newModel, cmd ) 
    CreateCustomer customer ->
      let
        cmd = model.api.create customer
      in
        ( model, cmd )
    UpdateCustomer customer ->
      let
        cmd = model.api.update customer
      in
        ( model, cmd )
    DeleteCustomer customer ->
      let
        cmd = model.api.delete customer
      in
        ( model, cmd )
    SelectCustomer id ->
      let
        maybeCustomer = Lx.find (\c -> c.id == id) model.customers
        (newModel, cmd) =
          case maybeCustomer of
            Nothing ->
              let
                error = "Can't find id " ++ id
                newModel = { model | errors = error :: model.errors }
                cmd = Cmd.batch
                  [ customerInTheEditor emptyCustomer
                  , errors newModel.errors
                  ]
              in
                ( newModel, cmd )
            Just customer ->
              ( model --{ model | selectedCustomer = customer }
              , customerInTheEditor customer
              )
      in
        (newModel, cmd)
    UpdateList ->
      let cmd = model.api.list
      in
        ( model, cmd)
    CustomerCreated id ->
      ( model, model.api.list )
    CustomerDeleted id ->
      ( model, model.api.list )
    CustomerUpdated customer ->
      ( model, model.api.list )

view : Model -> Html Msg
view model =
  div [] [ text "Done" ]

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ createCustomer CreateCustomer
    , deleteCustomer DeleteCustomer 
    , updateCustomer UpdateCustomer 
    , selectCustomer SelectCustomer
    , updateList (\_ -> UpdateList)
    ]

main : Program Flags Model Msg
main =
  Html.programWithFlags
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
