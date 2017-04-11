module SendFunctions exposing (..)

-- imports are weird for Native modules
-- You import them as you would normal modules
-- but you can't alias them nor expose stuff from them
import Native.SendFunctions

-- this will be our function which returns a number plus one
addOne : Int -> Int
addOne = Native.SendFunctions.addOne

functionToString : (Int -> String) -> String
functionToString = Native.SendFunctions.functionToString

