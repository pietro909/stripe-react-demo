module ExportFunction exposing (functionToString, functionToString2)

-- imports are weird for Native modules
-- You import them as you would normal modules
-- but you can't alias them nor expose stuff from them
import Native.ExportFunction
import Models exposing (Model)

type alias Function =
  { name : String
  , func : String
  }

-- this will be our function which returns a number plus one
modelToString : (Model -> String) -> Function
modelToString = Native.ExportFunction.functionToString

