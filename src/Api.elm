module Api exposing (API, getAPI)

import Http exposing (..)
import Json.Encode
import Json.Decode exposing (Decoder, decodeValue, int, float, list, string)
import Json.Decode.Pipeline exposing (decode, required, requiredAt, optional, optionalAt)
import Task

import Models exposing (Customer)
import Messages exposing (..)

type alias API =
  { create : Customer -> Cmd Msg
  , update : Customer -> Cmd Msg
  , delete : Customer -> Cmd Msg
  , list : Cmd Msg
  }

getAPI : String -> API
getAPI token =
  { create = create token
  , update = update token
  , delete = delete token
  , list = readAll token
  }

baseUrl = "https://api.stripe.com/v1/customers"
urlWithId id = baseUrl ++ "/" ++ id

encodeParam : String -> String -> String
encodeParam key value =
  (encodeUri key) ++ "=" ++ (encodeUri value)

normalizeData : Customer -> String
normalizeData customer =
  String.join "&"
    [ encodeParam "account_balance" (toString (customer.balance * 1000))
    , encodeParam "description" customer.description
    , encodeParam "email" customer.email
    , encodeParam "metadata[firstName]" customer.firstName
    , encodeParam "metadata[lastName]" customer.lastName
    ]

makeRequest : String -> String -> String -> Body -> Decoder a -> Request a
makeRequest token method url body resultDecoder =
  request
    { method = method
    , headers = [ header "Authorization" ("Bearer " ++ token) ]
    , url = url
    , body = body
    , expect = expectJson resultDecoder
    , timeout = Nothing
    , withCredentials = False
    }


customersDecoder : Decoder (List Customer)
customersDecoder =
  Json.Decode.at [ "data" ]
    (list customerDecoder)

customerDecoder : Decoder Customer
customerDecoder =
  decode Customer
    |> required "account_balance" float
    |> optional "description" string ""
    |> optional "email" string ""
    |> optionalAt [ "metadata", "firstName" ] string ""
    |> required "id" string
    |> optionalAt [ "metadata", "lastName" ] string ""

create : String -> Customer -> Cmd Msg
create token customer =
  let
    body = customer
      |> normalizeData
      |> Http.stringBody "application/x-www-form-urlencoded"
    post = makeRequest token "post" baseUrl body customerDecoder
  in
    Http.send CustomerCreated post

update : String -> Customer -> Cmd Msg
update token customer =
  let
    body = customer
      |> normalizeData
      |> Http.stringBody "application/x-www-form-urlencoded"
    post = makeRequest token "post" (urlWithId customer.id) body customerDecoder
  in
    Http.send CustomerUpdated post

delete : String -> Customer -> Cmd Msg
delete token customer =
  Json.Decode.at [ "id" ] string
    |> makeRequest token "delete" (urlWithId customer.id) Http.emptyBody
    |> Http.send CustomerDeleted

readAll : String -> Cmd Msg
readAll token =
  customersDecoder
    |> makeRequest token "get" baseUrl Http.emptyBody
    |> Http.send Customers

