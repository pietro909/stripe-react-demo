port module ElmApp exposing (main)

import Platform
import List.Extra as Lx
import Dict

import Api exposing (..)
import Models exposing (..)
import Messages exposing (..)
import Form
import Validation

port errors : List String -> Cmd msg
port customers : List Customer -> Cmd msg
port customerInTheEditor : Customer -> Cmd msg
port started : Bool -> Cmd msg

port start : (Config -> msg) -> Sub msg
port createCustomer : (() -> msg) -> Sub msg
port updateCustomer : (Customer -> msg) -> Sub msg
port deleteCustomer : (Customer -> msg) -> Sub msg
port selectCustomer : (String -> msg) -> Sub msg
port updateList : (() -> msg) -> Sub msg

type alias Model =
  { customers : List Customer
  , customerInTheEditor : Customer
  , errors : List String
  , config : Config
  , form : Form.Model
  }

initialModel : Model
initialModel =
  { customers = []
  , customerInTheEditor = emptyCustomer 
  , errors = []
  , config = Config ""
  , form = Form.initialModel
  }

initialCommand : Cmd Msg
initialCommand = Cmd.map FormMessage Form.initialCommand

init : (Model, Cmd Msg)
init =
  ( initialModel, initialCommand )

formToCustomer : Form.Model -> Maybe Customer
formToCustomer form =
  let
    balance = Just 0.3
    description =
      Dict.get "description" form.fields
        |> Maybe.andThen (\f -> Result.toMaybe <| Validation.unboxString f.value)
    email =
      Dict.get "email" form.fields
        |> Maybe.andThen (\f -> Result.toMaybe <| Validation.unboxString f.value)
    firstName =
      Dict.get "firstName" form.fields
        |> Maybe.andThen (\f -> Result.toMaybe <| Validation.unboxString f.value)
    id = 
      Dict.get "id" form.fields
        |> Maybe.andThen (\f -> Result.toMaybe <| Validation.unboxString f.value)
        |> Maybe.withDefault ""
    lastName =
      Dict.get "lastName" form.fields
        |> Maybe.andThen (\f -> Result.toMaybe <| Validation.unboxString f.value)
  in
    case (balance, description, email, firstName, lastName) of
      (Just b, Just d, Just e, Just fn, Just ln) ->
        Just <| (Debug.log "c" (Customer b d e fn id ln))
      _ -> Nothing

actionLogger : (Msg -> Model -> (Model, Cmd Msg)) -> Msg -> Model -> (Model, Cmd Msg)
actionLogger f msg model =
  let
    m = Debug.log "message" msg
  in
    f m model

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Start config ->
      let
        newModel = { model | config = config }
      in 
        (newModel, started True)
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
    CreateCustomer ->
      case (formToCustomer model.form) of
        Just c ->
          let cmd = Api.create model.config.apiKey c
          in
            ( model, cmd )
        Nothing ->
          ( model, Cmd.none )
    UpdateCustomer customer ->
      let
        cmd = Api.update model.config.apiKey customer
      in
        ( model, cmd )
    DeleteCustomer customer ->
      let
        cmd = Api.delete model.config.apiKey customer
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
                newModel =
                  { model
                    | errors = error :: model.errors
                    , form = Form.initialModel
                  }
                cmd = Cmd.batch
                  [ Cmd.map FormMessage (Form.formUpdated (Form.encodeModel newModel.form))
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
      let cmd = Api.readAll model.config.apiKey
      in
        ( model, cmd)
    CustomerCreated id ->
      ( model, Api.readAll model.config.apiKey )
    CustomerDeleted id ->
      ( model, Api.readAll model.config.apiKey )
    CustomerUpdated customer ->
      ( model, Api.readAll model.config.apiKey )
    FormMessage msg ->
      let
        (form, formCmd) = Form.update msg model.form
        newModel = { model | form = form }
        cmd = Cmd.map FormMessage formCmd
      in
        (newModel, cmd)

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ createCustomer (\_ -> CreateCustomer)
    , deleteCustomer DeleteCustomer 
    , updateCustomer UpdateCustomer 
    , selectCustomer SelectCustomer
    , updateList (\_ -> UpdateList)
    , start Start
    , Sub.map FormMessage (Form.subscriptions model.form)
    ]

main : Program Never Model Msg
main =
  Platform.program
    { init = init
    , update = actionLogger update
    , subscriptions = subscriptions
    }
