port module Form exposing (..)

type alias FormInput = (String, String)
type alias FormField a =
  { active : Bool
  , dirty : Bool
  , disabled : Bool
  , name : String
  , value : a
  }

makeFormField : String -> a -> FormField a
makeFormField name value =
  FormField False False False name value

updateFormFieldValue : a -> FormField a -> FormField a
updateFormFieldValue value field =
  FormField field.active field.dirty field.disabled field.name value

-- IN
port updateForm : (FormInput -> msg) -> Sub msg
-- OUT
port formUpdated : Model -> Cmd msg

type alias Model = 
  { firstName : FormField String
  , lastName : FormField String
  }

initialModel =
  { firstName = makeFormField "firstName" ""
  , lastName = makeFormField "lastName" ""
  }

initialCommand =
  formUpdated initialModel

type Msg
  = UpdateFormField FormInput

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    UpdateFormField (name, value) ->
      let
        newModel =
          case name of
            "firstName" -> 
              { model | firstName = updateFormFieldValue value model.firstName }
            "lastName" -> 
              { model | lastName = updateFormFieldValue value model.lastName }
            _ -> Debug.crash "oh figa"
      in
        (newModel, formUpdated newModel)

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ updateForm UpdateFormField ]
