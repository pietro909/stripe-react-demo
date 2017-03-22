port module Form exposing (..)

import Dict exposing (Dict)
import Json.Encode as JEnc

type alias FormInput = (String, String)
type FieldType
  = FTString String
  | FTFloat Float

type alias FormField =
  { active : Bool
  , dirty : Bool
  , disabled : Bool
  , name : String
  , value : FieldType
  }

type alias FormState =
  { dirty : Bool
  , hasErrors : Bool
  }

makeFormField : String -> FieldType -> FormField
makeFormField name value =
  FormField False False False name value

updateFormFieldValue : (FieldType -> Bool) -> FieldType -> FormField -> Maybe FormField
updateFormFieldValue validate value field =
  if (validate value) then
    Just (FormField field.active field.dirty field.disabled field.name value)
  else Nothing

stringToFloat : String -> Float -> Float
stringToFloat string fallback =
  case (String.toFloat string) of
    Ok f -> f
    Err _ -> fallback

-- IN
port updateForm : (FormInput -> msg) -> Sub msg
-- OUT
port formUpdated : ModelOut -> Cmd msg

type alias ModelOut =
  { fields : JEnc.Value }

type alias Model = 
  { fields : Dict String FormField 
  , state : FormState
  }

initialModel =
  { fields =
    Dict.empty
      |> Dict.insert "balance" (makeFormField "balance" <| FTFloat 0.0)
      |> Dict.insert "description" (makeFormField "description" <| FTString "")
      |> Dict.insert "email" (makeFormField "email" <| FTString "")
      |> Dict.insert "firstName" (makeFormField "firstName" <| FTString "")
      |> Dict.insert "lastName" (makeFormField "lastName" <| FTString "")
  , state = FormState False False
  }

initialCommand =
  formUpdated (encodeModel initialModel)

type Msg
  = UpdateFormField FormInput

validateTrue : a -> Bool
validateTrue v = True

uff : FieldType -> Maybe FormField -> Maybe FormField
uff value maybeField =
  Maybe.map
    (\f -> FormField f.active f.dirty f.disabled f.name value)
    maybeField

updateFormField : String -> String -> Model -> Model
updateFormField name value model =
  let
    updated : Dict String FormField
    updated = Dict.update name (uff <| FTString value) model.fields
  in
    { model | fields = updated }

    {--
    "firstName" -> 
      let
        case (updateFormFieldValue valididateTrue value model.firstName) of
          Just field ->
          Nothing ->
        
      --}


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    UpdateFormField (name, value) ->
      let
        newModel = updateFormField name value model
      in
        (newModel, formUpdated (encodeModel newModel))

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ updateForm UpdateFormField ]

fieldValueToJson : FieldType -> JEnc.Value
fieldValueToJson value =
  case value of
    FTString s -> JEnc.string s
    FTFloat f -> JEnc.float f

fieldToJson : FormField -> JEnc.Value
fieldToJson field =
  JEnc.object
    [ ("active", JEnc.bool field.active)
    , ("dirty", JEnc.bool field.dirty)
    , ("disabled", JEnc.bool field.disabled)
    , ("name", JEnc.string field.name)
    , ("value", fieldValueToJson field.value)
    ]

encodeModel : Model -> ModelOut
encodeModel model =
  let
    fields =
      Dict.toList model.fields
        |> List.map (\(k,v) -> (k, fieldToJson v))
        |> JEnc.object
  in
    { fields = fields }
