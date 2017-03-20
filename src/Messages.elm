module Messages exposing (..)

import Http

import Models exposing (..)

type Msg
  = Customers (Result Http.Error (List Customer))
  | CreateCustomer Customer
  | CustomerCreated (Result Http.Error Customer)
  | CustomerDeleted (Result Http.Error String)
  | CustomerUpdated (Result Http.Error Customer)
  | DeleteCustomer Customer
  | SelectCustomer String
  | UpdateCustomer Customer
  | UpdateList
