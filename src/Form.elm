port module Form exposing (..)

type alias FormInput = (String, String)
type alias FormField a =
  { active : Bool
  , dirty : Bool
  , disabled : Bool
  , name : String
  , value : a
  }

type alias FormState =
  { dirty : Bool
  , hasErrors : Bool
  }

makeFormField : String -> a -> FormField a
makeFormField name value =
  FormField False False False name value

updateFormFieldValue : a -> FormField a -> FormField a
updateFormFieldValue value field =
  FormField field.active field.dirty field.disabled field.name value

stringToFloat : String -> Float -> Float
stringToFloat string fallback =
  case (String.toFloat string) of
    Ok f -> f
    Err _ -> fallback

-- IN
port updateForm : (FormInput -> msg) -> Sub msg
-- OUT
port formUpdated : Model -> Cmd msg

type alias Model = 
  { firstName : FormField String
  , lastName : FormField String
  , balance : FormField Float
  , email : FormField String
  , description : FormField String
  , state : FormState
  }

initialModel =
  { firstName = makeFormField "firstName" ""
  , lastName = makeFormField "lastName" ""
  , balance = makeFormField "balance" 0.0
  , email = makeFormField "email" ""
  , description = makeFormField "description" ""
  , state = FormState False False
  }

initialCommand =
  formUpdated initialModel

type Msg
  = UpdateFormField FormInput

updateFormField : String -> String -> Model -> Model
updateFormField name value model =
  case name of
    "firstName" -> 
      { model | firstName = updateFormFieldValue value model.firstName }
    "lastName" -> 
      { model 
        | lastName = updateFormFieldValue value model.lastName }
    "balance" -> 
      { model | balance = updateFormFieldValue (stringToFloat value 0.0) model.balance } 
    "email" -> 
      { model | email = updateFormFieldValue value model.email }
    "description" -> 
      { model | description = updateFormFieldValue value model.description }
    _ -> Debug.crash ("Illegal from field " ++ name)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    UpdateFormField (name, value) ->
      let
        newModel = updateFormField name value model
      in
        (newModel, formUpdated newModel)

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ updateForm UpdateFormField ]
