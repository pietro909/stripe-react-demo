module Types exposing (..)

type alias Customer =
  { balance : Float
  , description : String
  , email : String
  , firstName : String
  , id : String
  , lastName : String
  }

type alias Model =
  { customers : List Customers }

type alias Msg
  = Customers <| Result Http.Error <| List Customer
  | SelectCustomer String
  | UpdateList


