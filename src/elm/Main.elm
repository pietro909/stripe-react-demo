port module ElmApp exposing (main)

import Platform
import List.Extra as Lx
import Dict

import Api exposing (..)
import Models exposing (..)
import Messages exposing (..)
import Form
import Validation

port statusMessages : StatusMessage -> Cmd msg
port errors : String -> Cmd msg

port customers : List Customer -> Cmd msg
port customerInTheEditor : Customer -> Cmd msg
port started : Bool -> Cmd msg
port navigateTo : String -> Cmd msg

port start : (Config -> msg) -> Sub msg
port createCustomer : (() -> msg) -> Sub msg
port updateCustomer : (() -> msg) -> Sub msg
port deleteCustomer : (() -> msg) -> Sub msg
port selectCustomer : (String -> msg) -> Sub msg
port updateList : (() -> msg) -> Sub msg
port setRoute : (String -> msg) -> Sub msg

type alias StatusMessage =
  { message : String
  , level : Int
  }

type alias Model =
  { customers : List Customer
  , customerInTheEditor : Customer
  , config : Config
  , form : Form.Model
  , router : Router
  }

initialModel : Model
initialModel =
  { customers = []
  , customerInTheEditor = emptyCustomer
  , config = Config ""
  , form = Form.initialModel
  , router = { path = "/" }
  }

-- takes an error msg, create a command to send it outside
errorHub : List String -> List (Cmd Msg)
errorHub errList =
  List.map errors errList

initialCommand : Cmd Msg
initialCommand = Cmd.map FormMessage Form.initialCommand

init : (Model, Cmd Msg)
init =
  ( initialModel, initialCommand )

type CumulativeResult a
  = Y a
  | N (List String)

getFieldValue name extractor fields =
  Dict.get name fields
    |> Result.fromMaybe (Validation.NoSuchField name)
    |> Result.andThen (\f -> extractor f.value)
    |> Result.mapError (\e -> Debug.log name e)

formToCustomer : Form.Model -> Result (List Validation.ConversionError) Customer
formToCustomer form =
  let
    balance = getFieldValue "balance" Validation.unboxFloat form.fields
    description = getFieldValue "description" Validation.unboxString form.fields
    email = getFieldValue "email" Validation.unboxString form.fields
    firstName = getFieldValue "firstName" Validation.unboxString form.fields
    id = getFieldValue "id" Validation.unboxString form.fields
    lastName = getFieldValue "lastName" Validation.unboxString form.fields
  in
    case (balance, description, email, firstName, id, lastName) of
      (Ok b, Ok d, Ok e, Ok fn, Ok i, Ok ln) ->
        Customer b d e fn i ln
          |> Ok
      _ ->
        filterErrors [description, email, firstName, id, lastName] ++
        filterErrors [balance]
          |> Err

filterErrors list =
  List.filterMap
    (\r ->
      case r of
        Err e -> Just e
        _ -> Nothing)
    list

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
        (message, startCmd) =
          if (String.isEmpty config.apiKey) then
            (StatusMessage "No API key found! check src/API.js and the README for more information." 3, Cmd.none)
          else
            (StatusMessage "Welcome to version 0.1" 1, Api.readAll config.apiKey)
        cmd = Cmd.batch
          [ statusMessages message
          , started True
          , startCmd
          ]
        newModel = { model | config = config }
      in
        (newModel, cmd)

    Customers (Err e) ->
      let
        infoCmd = statusMessages <| StatusMessage (errorExtractor e) 3
      in
        (model, infoCmd)
    Customers (Ok list) ->
      let
        newModel = { model | customers = list }
        customersCmd = customers list
        infoCmd = statusMessages
            <| StatusMessage ("Read " ++ (toString <| List.length list) ++ " customers.") 1
        cmd = Cmd.batch [ infoCmd, customersCmd ]
      in
        ( newModel, cmd )

    CreateCustomer ->
      let
        resultCmd = formToCustomer model.form
          |> Result.map (Api.create model.config.apiKey)
          |> Result.mapError (\le -> errorHub <| (List.map toString le))
        creationCmd =
          case resultCmd of
            Ok c -> c
            Err c -> Cmd.batch c
        infoCmd = statusMessages  <| StatusMessage "Creating customer..." 2
        cmd = Cmd.batch [ infoCmd, creationCmd ]
      in
        ( model, cmd )

    UpdateCustomer ->
      let
        resultCmd = formToCustomer model.form
          |> Result.map (Api.update model.config.apiKey)
          |> Result.mapError (\le -> errorHub <| (List.map toString le))
        updateCmd =
          case resultCmd of
            Ok c -> c
            Err c -> Cmd.batch c
        infoCmd = statusMessages <| StatusMessage "Updating customer..." 2
        cmd = Cmd.batch [ infoCmd, updateCmd ]
      in
        ( model, cmd )

    DeleteCustomer ->
      let
        resultCmd = formToCustomer model.form
          |> Result.map (Api.delete model.config.apiKey)
          |> Result.mapError (\le -> errorHub <| (List.map toString le))
        deleteCmd =
          case resultCmd of
            Ok c -> c
            Err c -> Cmd.batch  c
        infoCmd =
            statusMessages <| StatusMessage "Deleting customer..." 2
        cmd = Cmd.batch [ infoCmd, deleteCmd ]

      in
        ( model, cmd )

    SelectCustomer id ->
      let
        maybeCustomer = Lx.find (\c -> c.id == id) model.customers
        (newModel, cmd) =
          case maybeCustomer of
            Just customer ->
              let
                form = Form.fromCustomer customer
                newModel = Debug.log "just" { model | form = form }
                formCmd =
                  Form.encodeModel form
                    |> Form.formUpdated
                    |> Cmd.map FormMessage
                message = statusMessages <| StatusMessage ("Selected #" ++ customer.id) 1
                cmd = Cmd.batch
                  [ formCmd, message ]
              in
                (newModel, cmd)

            Nothing ->
              let
                newModel =
                  { model | form = Form.initialModel }
                cmd =
                  Form.encodeModel newModel.form
                    |> Form.formUpdated
                    |> Cmd.map FormMessage
                navigationCmd =
                  navigateTo "404"
              in
                ( newModel, Cmd.batch [ cmd, navigationCmd ])
      in
        (newModel, cmd)
    UpdateList ->
      let
        readCmd = Api.readAll model.config.apiKey
        infoCmd = statusMessages <| StatusMessage "Fetching customers..." 2
        cmd = Cmd.batch [ infoCmd, readCmd ]
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

    SetRoute path ->
      -- TODO: just tracking the route's change here
      let
        router = updateRouter model.router path
        newModel = { model | router = router }
      in
        (newModel, Cmd.none)

updateRouter : Router -> String -> Router
updateRouter router path =
  { path = path }

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ createCustomer (\_ -> CreateCustomer)
    , deleteCustomer (\_ -> DeleteCustomer)
    , updateCustomer (\_ -> UpdateCustomer)
    , selectCustomer SelectCustomer
    , updateList (\_ -> UpdateList)
    , start Start
    , setRoute SetRoute
    , Sub.map FormMessage (Form.subscriptions model.form)
    ]

main : Program Never Model Msg
main =
  Platform.program
    { init = init
    , update = update --actionLogger update
    , subscriptions = subscriptions
    }
