module Api exposing (readAll)

import Http exposing (Http)
import Json.Encode
import Json.Decode exposing (Decoder, decodeString, decodeValue, int, float, list, string)
import Json.Decode.Pipeline exposing (decode, required, requiredAt, optional, optionalAt)
import Types exposing (Customers)

baseUrl = "https://api.stripe.com/v1/customers"

customersDecoder : Decoder (List Customer)
customersDecoder =
  Json.Decode.at [ "data" ]
    (list customerDecoder)


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

readAll : String -> Cmd Msg
readAll token =
  customersDecoder
    |> makeRequest token "get" baseUrl Http.emptyBody
    |> Http.send Customers

