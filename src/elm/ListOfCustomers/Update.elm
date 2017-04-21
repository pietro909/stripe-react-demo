module Update exposing (update)

import Types exposing (..)
import State exposing (..)
import Ports as ports
import Api


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of

    Customers (Err e) ->
      let
        infoCmd = Cmd.none --statusMessages <| StatusMessage (errorExtractor e) 3
      in
        (model, infoCmd)

    Customers (Ok list) ->
      let
        newModel = { model | customers = list }
        customersCmd = ports.customers list
        infoCmd = Cmd.none
        --statusMessages
         --   <| StatusMessage ("Read " ++ (toString <| List.length list) ++ " customers.") 1
        cmd = Cmd.batch [ infoCmd, customersCmd ]
      in
        (newModel, cmd )

    UpdateList ->
      let
        readCmd = Api.readAll model.config.apiKey
        infoCmd = Cmd.none --statusMessages <| StatusMessage "Fetching customers..." 2
        cmd = Cmd.batch [ infoCmd, readCmd ]
      in
        (model, cmd)

