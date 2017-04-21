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

type alias Config =
  { apiKey : String }

type alias Router =
  { path: String }

type alias Destination =
  { path: String
  , component: String
  }

