module Validation exposing (..)

import Regex

type ConversionError
  = NoSuchField String
  | NotAFloat String
  | NotAString String

type FieldType
  = FTString String
  | FTFloat Float

digitsOnly : String -> String
digitsOnly s =
  Regex.replace Regex.All (Regex.regex "[^\\d.]") (\_ -> "") s

typeForFieldFloat : String -> FieldType
typeForFieldFloat s =
  String.toFloat (digitsOnly s)
    |> Result.toMaybe
    |> Maybe.withDefault 0.0
    |> FTFloat

unboxFloat : FieldType -> Result ConversionError Float
unboxFloat t =
  case t of
    FTFloat f -> Ok f
    _ -> Err <| NotAFloat (toString t)

unboxString : FieldType -> Result ConversionError String
unboxString t =
  case t of
    FTString s -> Ok s
    _ -> Err <| NotAString (toString t)
