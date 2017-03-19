module Messages exposing (..)

import Http

import Models exposing (..)

type Msg
  = Customers (Result Http.Error (List Customer))
  | AddCustomer String
  | UpdateList
  | CustomerCreated (Result Http.Error Customer)
