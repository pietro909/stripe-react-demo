module Messages exposing (..)

import Http

import Models exposing (..)
import Form

type Msg
  = Customers (Result Http.Error (List Customer))
  | CreateCustomer 
  | CustomerCreated (Result Http.Error Customer)
  | CustomerDeleted (Result Http.Error String)
  | CustomerUpdated (Result Http.Error Customer)
  | DeleteCustomer Customer
  | SelectCustomer String
  | UpdateCustomer Customer
  | UpdateList
  | FormMessage Form.Msg
  | Start Config
