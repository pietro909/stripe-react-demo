module Api exposing (..)

import Http exposing (..)
import Json.Encode
import Json.Decode exposing (Decoder, decodeValue, int, float, list, string)
import Json.Decode.Pipeline exposing (decode, required, requiredAt, optional, optionalAt)
import Task

import Models exposing (Customer)
import Messages exposing (..)

{--
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
--}

api_key = ""
baseUrl = "https://api.stripe.com/v1/customers"
urlWithId id = baseUrl ++ "/" ++ id

encodeParam : String -> String -> String
encodeParam key value =
  (encodeUri key) ++ "=" ++ (encodeUri value)

makeRequest : String -> String -> Body -> Decoder a -> Request a
makeRequest method url body resultDecoder =
  request
    { method = method
    , headers = [ header "Authorization" ("Bearer " ++ api_key) ]
    , url = url
    , body = body
    , expect = expectJson resultDecoder
    , timeout = Nothing
    , withCredentials = False
    }

normalizeData : Customer -> String
normalizeData customer =
  String.join "&"
    [ encodeParam "account_balance" (toString (customer.balance * 1000))
    , encodeParam "description" customer.description
    , encodeParam "email" customer.email
    , encodeParam "metadata[firstName]" customer.firstName
    , encodeParam "metadata[lastName]" customer.lastName
    ]

customersDecoder : Decoder (List Customer)
customersDecoder =
  Json.Decode.at [ "data" ]
    (list customerDecoder)
  --§decodeValue (list customerDecoder) 

customerDecoder : Decoder Customer
customerDecoder =
  decode Customer
    |> required "account_balance" float
    |> optional "description" string ""
    |> optional "email" string ""
    |> optionalAt [ "metadata", "firstName" ] string ""
    |> required "id" string
    |> optionalAt [ "metadata", "lastName" ] string ""

create : Customer -> Cmd Msg
create customer =
  let
    body = customer
      |> normalizeData
      |> Http.stringBody "application/x-www-form-urlencoded"
    post = makeRequest "post" baseUrl body customerDecoder
  in
    Http.send CustomerCreated post

readAll : Cmd Msg
readAll =
  customersDecoder
    |> makeRequest "get" baseUrl Http.emptyBody --customerDecoder
    |> Http.send Customers


