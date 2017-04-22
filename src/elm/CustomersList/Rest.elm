module CustomersList.Rest exposing (..)


import Http

import Api exposing (customersDecoder, makeRequest, baseUrl)

import CustomersList.Types exposing (..)


readAll : String -> Cmd Msg
readAll token =
  customersDecoder
    |> makeRequest token "get" baseUrl Http.emptyBody
    |> Http.send Customers

