port module ElmApp exposing (main)


import Dict
import List.Extra as Lx
import Navigation
import Platform


import CustomersList.CustomersList as CustomersList
import CustomersList.Ports as CustomersListPorts
import CustomersList.Types as CustomersListTypes
import Form.Form as Form
import Form.Ports as FormPorts
import Form.Types as FormTypes
import Form.Validation as Validation
import Native.ExportFunction
import Router.Ports as RouterPorts
import Router.Router as Router
import Router.Router as Router
import Router.Types as RouterTypes

import Api exposing (..)
import Messages exposing (..)
import Models exposing (..)

import Api exposing (..)
import Messages exposing (..)
import Models exposing (..)


port statusMessages : StatusMessage -> Cmd msg
port errors : String -> Cmd msg

port started : Bool -> Cmd msg
port navigateTo : String -> Cmd msg
port selectors : List String -> Cmd msg
--port state : Model -> Cmd msg

port start : (Config -> msg) -> Sub msg
port createCustomer : (() -> msg) -> Sub msg
port updateCustomer : (() -> msg) -> Sub msg
port deleteCustomer : (() -> msg) -> Sub msg
port setRoute : (String -> msg) -> Sub msg


type alias StatusMessage =
  { message : String
  , level : Int
  }

type alias Model =
  { customersList : CustomersListTypes.Model
  , selectedCustomerId: Maybe String
  , config : Config
  , form : FormTypes.Model
  , router : RouterTypes.Model
  , history : List Navigation.Location
  }


-- takes an error msg, create a command to send it outside
errorHub : List String -> List (Cmd Msg)
errorHub errList =
  List.map errors errList

initialCommand : Cmd Msg
initialCommand = Cmd.map FormMsg Form.initialCommand

init : Navigation.Location -> ( Model, Cmd Msg )
init location =
  let
    (routerModel, routerCmd) =
      Router.update ( RouterTypes.LocationChanged location)
        <| Router.initialModel location
    initialModel : Model
    initialModel =
      { customersList = CustomersList.initialModel
      , selectedCustomerId = Nothing
      , config = Config ""
      , form = Form.initialModel
      , router = Router.initialModel location
      , history = []
      }
    initialCommand =
      Cmd.batch [ Cmd.map RouterMsg routerCmd ]
  in
    ( initialModel, initialCommand )

getFieldValue name extractor fields =
  Dict.get name fields
    |> Result.fromMaybe (Validation.NoSuchField name)
    |> Result.andThen (\f -> extractor f.value)
    |> Result.mapError (\e -> Debug.log name e)

formToCustomer : FormTypes.Model -> Result (List Validation.ConversionError) Customer
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
            ( StatusMessage "Welcome to version 0.1" 1
            , Cmd.map CustomersListMsg <| CustomersList.fetchAll config.apiKey
            )
        cmd = Cmd.batch
          [ statusMessages message
          , started True
          , startCmd
          ]
        newModel = { model | config = config } --, router = routerModel }
      in
        (newModel, cmd)

    CustomerFound result ->
      case result of
        Ok customer ->
          -- update the form
          customerToModelCmd model customer
          -- send the form out
        Err e ->
          (model, goto404)

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

    CustomerCreated result ->
      let
        subCmd = CustomersList.fetchAll model.config.apiKey
        cmd = Cmd.map CustomersListMsg subCmd
      in
        (model, cmd)

    CustomerDeleted result ->
      let
        subCmd = CustomersList.fetchAll model.config.apiKey
        cmd = Cmd.map CustomersListMsg subCmd
      in
        (model, cmd)

    CustomerUpdated result ->
      let
        subCmd = CustomersList.fetchAll model.config.apiKey
        cmd = Cmd.map CustomersListMsg subCmd
      in
        (model, cmd)

    CustomersListMsg msg ->
      let
        (subModel, subCmd) =
          CustomersList.update model.config msg model.customersList
        newModel = { model | customersList = subModel }
        cmd = Cmd.map CustomersListMsg subCmd
      in
        (newModel, cmd)

    FormMsg msg ->
      let
        (subModel, subCmd) = Form.update msg model.form
        newModel = { model | form = subModel }
        cmd = Cmd.map FormMsg subCmd
      in
        (newModel, cmd)

    RouterMsg msg ->
      handleRouterMsg msg model


goto404 : Cmd Msg
goto404 =
  Navigation.newUrl "404"


customerToModelCmd : Model -> Customer -> (Model, Cmd Msg)
customerToModelCmd model customer =
  let
    (subModel, subCmd) = Form.fillForm customer
    cmd = Cmd.map FormMsg subCmd
    newModel = { model | form = subModel }
  in
    (newModel, cmd)


findCustomerByIdOr404 : String -> Model -> (Model, Cmd Msg)
findCustomerByIdOr404 id model =
  CustomersList.findById id model.customersList
  |> Maybe.map (customerToModelCmd model)
  |> Maybe.withDefault ({ model | form = Form.initialModel}, Api.edit model.config.apiKey id)
  --|> Maybe.withDefault ({ model | form = Form.initialModel}, goto404)
  -- TODO: if not in the list, try to call the server. If fails, 404


locationUpdate : Navigation.Location -> Model -> (Model, Cmd Msg)
locationUpdate location model =
  let
    (subModel, subCmd) = Router.onLocationChange location
    newModel = { model | router = subModel }
    cmd = Cmd.map RouterMsg subCmd
  in
    (newModel, cmd)


handleRouterMsg : RouterTypes.Msg -> Model -> (Model, Cmd Msg)
handleRouterMsg msg model =
  let
    (routerModel, routerCmd) = Router.update msg model.router
    (foundModel, dataCmd) =
      case msg of
        RouterTypes.LocationChanged location ->
          case routerModel.route of
            RouterTypes.Edit id ->
              findCustomerByIdOr404 id model
            RouterTypes.Create ->
              customerToModelCmd model emptyCustomer
            _ ->
              locationUpdate location model
        _ ->
          (model, Cmd.none)
    newModel = { foundModel | router = routerModel }
    cmd =
      Cmd.batch
        [ Cmd.map RouterMsg routerCmd
        , dataCmd
        ]
  in
    (newModel, cmd)


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ createCustomer (\_ -> CreateCustomer)
    , deleteCustomer (\_ -> DeleteCustomer)
    , updateCustomer (\_ -> UpdateCustomer)
    , start Start
    , Sub.map RouterMsg (Router.subscriptions model.router)
    , Sub.map CustomersListMsg
        <| CustomersList.subscriptions model.customersList
    , Sub.map FormMsg (Form.subscriptions model.form)
    ]


main : Program Never Model Msg
main =
  Navigation.headlessProgram (\l -> RouterMsg <| RouterTypes.LocationChanged l)
    { init = init
    , update = actionLogger update
    , subscriptions = subscriptions
    }
