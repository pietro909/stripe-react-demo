module CustomersList.CustomersList exposing (
  initialModel, update, subscriptions, findById, fetchAll)

import List.Extra as Lx

import CustomersList.Ports as Ports
import CustomersList.Rest as Rest
import CustomersList.Types exposing (..)

import Models exposing (Config, Customer)


fetchAll : String -> Cmd Msg
fetchAll token =
  Rest.readAll token


findById : String -> Model -> Maybe Customer
findById id model = Lx.find (\c -> c.id == id) model.customers


initialModel : Model
initialModel =
  { customers = [] }


update : Config -> Msg -> Model -> (Model, Cmd Msg)
update config msg model =
  case msg of

    Customers (Err e) ->
      let
        infoCmd = Cmd.none --statusMessages <| StatusMessage (errorExtractor e) 3
      in
        (model, infoCmd)

    Customers (Ok list) ->
      let
        newModel = { model | customers = list }
        customersCmd = Ports.customers list
        infoCmd = Cmd.none
          --statusMessages
           -- <| StatusMessage ("Read " ++ (toString <| List.length list) ++ " customers.") 1
        cmd = Cmd.batch [ infoCmd, customersCmd ]
      in
        ( newModel, cmd )

    UpdateList ->
      let
        readCmd = Rest.readAll config.apiKey
        -- infoCmd = statusMessages <| StatusMessage "Fetching customers..." 2
        cmd = readCmd --Cmd.batch [ infoCmd, readCmd ]
      in
        ( model, cmd)


subscriptions : Model -> Sub Msg
subscriptions model =
  Ports.updateList (\_ -> UpdateList)
