module Api exposing (..)

import Http exposing (..)
import Json.Decode exposing (Decoder, decodeString, list, string)
import Json.Encode
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
headers =
  [ header "Authorization" ("Bearer " ++ api_key)
  --, header "Content-Type" "application/x-www-form-urlencoded"
  ]

encodeParam : String -> String -> String
encodeParam key value =
  (encodeUri key) ++ "=" ++ (encodeUri value)

makeRequest : String -> String -> Body -> Decoder a -> Request a
makeRequest method url body resultDecoder =
  request
    { method = method
    , headers = headers
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

decoder : Json.Decode.Decoder String
decoder =
    Json.Decode.at [ "id" ]
       ( Json.Decode.string )

create : Customer -> Cmd Msg
create customer =
  let
    body = customer
      |> normalizeData
      --|> Json.Encode.encode 0
      |> Http.stringBody "application/x-www-form-urlencoded"
    post : Http.Request String
    post = makeRequest "post" baseUrl body decoder
  in
    Http.send CustomerCreated post
