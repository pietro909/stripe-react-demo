module Models exposing (..)

type alias Customer =
  { balance : Float
  , description : String
  , email : String
  , firstName : String
  , id : String
  , lastName : String
  }

emptyCustomer =
  Customer 0.0 "" "" "" "" ""

