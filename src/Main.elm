port module ElmApp exposing (main)

import Platform
import List.Extra as Lx

import Api exposing (..)
import Models exposing (..)
import Messages exposing (..)
import Form

port errors : List String -> Cmd msg
port customers : List Customer -> Cmd msg
port customerInTheEditor : Customer -> Cmd msg
port started : Bool -> Cmd msg

port start : (Config -> msg) -> Sub msg
port createCustomer : (Customer -> msg) -> Sub msg
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
    CreateCustomer customer ->
      let
        cmd = Api.create model.config.apiKey customer
      in
        ( model, cmd )
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
    [ createCustomer CreateCustomer
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
    , update = update
    , subscriptions = subscriptions
    }
