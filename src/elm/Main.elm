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
import Router.NavigationProgram
import Router.Ports as RouterPorts

import Api exposing (..)
import Messages exposing (..)
import Models exposing (..)


port statusMessages : StatusMessage -> Cmd msg
port errors : String -> Cmd msg

port customerInTheEditor : Customer -> Cmd msg
port started : Bool -> Cmd msg
port navigateTo : String -> Cmd msg
port selectors : List String -> Cmd msg
--port state : Model -> Cmd msg

port start : (Config -> msg) -> Sub msg
port createCustomer : (() -> msg) -> Sub msg
port updateCustomer : (() -> msg) -> Sub msg
port deleteCustomer : (() -> msg) -> Sub msg
port selectCustomer : (String -> msg) -> Sub msg
port setRoute : (String -> msg) -> Sub msg


type alias StatusMessage =
  { message : String
  , level : Int
  }

type alias Model =
  { customersList : CustomersListTypes.Model
  , customerInTheEditor : Customer
  , config : Config
  , form : FormTypes.Model
  , router : Router
  }


initialModel : Model
initialModel =
  { customersList = CustomersList.initialModel
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
initialCommand = Cmd.map FormMsg Form.initialCommand

init : Navigation.Location -> ( Model, Cmd Msg )
init location =
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
          , RouterPorts.destination { path = "/", component = "List" }
          , startCmd
          ]
        newModel = { model | config = config }
      in
        (newModel, cmd)


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
        maybeCustomer = CustomersList.findById id model.customersList
        (newModel, cmd) =
          case maybeCustomer of
            Just customer ->
              let
                form = Form.fromCustomer customer
                newModel = Debug.log "just" { model | form = form }
                formCmd =
                  Form.encodeModel form
                    |> FormPorts.formUpdated
                    |> Cmd.map FormMsg
                message = statusMessages <| StatusMessage ("Selected #" ++ customer.id) 1
                navigationCmd =
                  navigateTo ("/edit/"++customer.id)

                -- TODO: doesn't work
                cmd = Cmd.batch
                  [ formCmd, message, navigationCmd ]
              in
                (newModel, cmd)

            Nothing ->
              let
                newModel =
                  { model | form = Form.initialModel }
                cmd =
                  Form.encodeModel newModel.form
                    |> FormPorts.formUpdated
                    |> Cmd.map FormMsg
                navigationCmd =
                  navigateTo "/404"
              in
                ( newModel, Cmd.batch [ cmd, navigationCmd ])
      in
        (newModel, cmd)
    CustomerCreated id ->
      let
        subCmd = CustomersList.fetchAll model.config.apiKey
        cmd = Cmd.map CustomersListMsg subCmd
      in
        (model, cmd)
    CustomerDeleted id ->
      let
        subCmd = CustomersList.fetchAll model.config.apiKey
        cmd = Cmd.map CustomersListMsg subCmd
      in
        (model, cmd)
    CustomerUpdated customer ->
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

    SetRoute path ->
      -- TODO: just tracking the route's change here
      let
        router = updateRouter model.router path
        newModel = { model | router = router }
      in
        (newModel, Cmd.none)

    UrlChange location ->
      (model, Cmd.none)

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
    , start Start
    , setRoute SetRoute
    , Sub.map CustomersListMsg
        <| CustomersList.subscriptions model.customersList
    , Sub.map FormMsg (Form.subscriptions model.form)
    ]


main : Program Never Model Msg
main =
  NavigationProgram.headlessProgram UrlChange
    { init = init
    , update = update --actionLogger update
    , subscriptions = subscriptions
    }
