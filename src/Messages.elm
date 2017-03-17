module Messages exposing (..)

import Http

type Msg
  = Customers (List String)
  | AddCustomer String
  | UpdateList
  | CustomerCreated (Result Http.Error String)
