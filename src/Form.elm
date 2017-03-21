port module Form exposing (..)

type alias FormInput = (String, String)

-- IN
port updateForm : (FormInput -> msg) -> Sub msg
-- OUT
port formUpdated : Model -> Cmd msg

type alias Model =
  { firstName : String }

initialModel =
  { firstName = "" }

type Msg
  = UpdateFormField FormInput

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    UpdateFormField (name, value) ->
      let
        newModel = { model | firstName = value }
      in
        (newModel, formUpdated newModel)

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ updateForm UpdateFormField ]
