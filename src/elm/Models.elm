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

  {--
  { match = {"path":"/","url":"/","isExact":true,"params":{}},"location":{"pathname":"/","search":"","hash":""},"history":{"length":3,"action":"POP","location":{"pathname":"/","search":"","hash":""}}}
  --}
