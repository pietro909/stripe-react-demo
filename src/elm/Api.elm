module Api exposing (
  baseUrl,
  create,
  customersDecoder,
  delete,
  errorExtractor,
  makeRequest,
  edit,
  update)

import Http exposing (..)
import Json.Encode
import Json.Decode exposing (Decoder, decodeString, decodeValue, int, float, list, string)
import Json.Decode.Pipeline exposing (decode, required, requiredAt, optional, optionalAt)
import Task


import Models exposing (Customer)
import Messages exposing (..)

errorDecoder : Json.Decode.Decoder String
errorDecoder =
    Json.Decode.at [ "error" ]
       ( Json.Decode.string )

errorExtractor : Error -> String
errorExtractor error =
  case error of
    BadStatus response ->
      Result.withDefault "Unknown error" (decodeString errorDecoder response.body)
    _ -> "We apologize, something went wrong."

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

edit : String -> String -> Cmd Msg
edit token id =
  customerDecoder
  |> makeRequest token "get" (urlWithId id) Http.emptyBody
  |> Http.send CustomerFound


