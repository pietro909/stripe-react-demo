module Form.Types exposing (..)


import Dict exposing (Dict)
import Json.Encode as JEnc

import Form.Validation exposing (FieldType)


type alias FormInput = (String, String)


type alias FormField =
  { active : Bool
  , dirty : Bool
  , disabled : Bool
  , name : String
  , validator : String -> FieldType
  , value : FieldType
  }


type alias FormState =
  { dirty : Bool
  , hasErrors : Bool
  }


type alias ModelOut =
  { fields : JEnc.Value }


type alias Model =
  { fields : Dict String FormField
  , state : FormState
  }


type Msg
  = UpdateFormField FormInput

