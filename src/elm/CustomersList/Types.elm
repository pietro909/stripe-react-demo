module CustomersList.Types exposing (..)

import Http
import Models exposing (Customer)


type alias Model =
  { customers : List Customer }


type Msg
  = Customers (Result Http.Error (List Customer))
  | UpdateList
