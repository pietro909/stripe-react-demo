module Validation exposing (..)

import Regex

type FieldType
  = FTString String
  | FTFloat Float

digitsOnly : String -> String
digitsOnly s =
  Regex.replace Regex.All (Regex.regex "[^\\d]") (\_ -> "") s

typeForFieldString : String -> FieldType
typeForFieldString s = 
  FTString s

typeForFieldFloat : String -> FieldType
typeForFieldFloat s =
  String.toFloat (digitsOnly s)
    |> Result.toMaybe
    |> Maybe.withDefault 0.0
    |> FTFloat

unboxFloat : FieldType -> Result String Float
unboxFloat t =
  case t of
    FTFloat f -> Ok f
    _ -> Err <| (toString t) ++ " is not a Float"

unboxString : FieldType -> Result String String
unboxString t =
  case t of
    FTString s -> Ok s
    _ -> Err <| (toString t) ++ " is not a String"
